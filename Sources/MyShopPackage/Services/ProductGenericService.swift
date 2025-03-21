//
//  ProductGenericService.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI
import FirebaseFirestore

public enum CallAPIStatus {
    case Idle
    case Loading
    case Success
    case Fail(Error)
}

public protocol ProductGenericService: ObservableObject {
    associatedtype ProductDT: ProductData
    associatedtype CategoryDT: CategoryData
    var product: ProductDT { get set }
    var products: [ProductDT] { get set }
    var callAPIStatus: CallAPIStatus { get set }
}

public extension ProductGenericService {
    
    func fetchAllProducts(completion: @escaping ([ProductDT]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("products")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }
                let products = documents.compactMap { doc -> ProductDT? in
                    try? doc.data(as: ProductDT.self)
                }
                completion(products)
            }
    }
    
    func fetchProducts(for category: CategoryDT
                       , completion: @escaping ([ProductDT]) -> Void) {
        let db = Firestore.firestore()
        db.collection("products")
            .whereField("category", isEqualTo: category.name)
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }
                let products = documents.compactMap { doc -> ProductDT? in
                    try? doc.data(as: ProductDT.self)
                }
                completion(products)
            }
    }
    
    func deleteProduct(_ product: ProductDT, conpletion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("products").document(product.id).delete { error in
            if let error = error {
                print("❌ Lỗi khi xóa sản phẩm: \(error.localizedDescription)")
                conpletion(false)
            } else {
                print("✅ Xóa sản phẩm thành công!")
                conpletion(true)
            }
        }
    }
    
    func addProduct(_ product: ProductDT, completion: @escaping () -> Void) {
        do {
            let db = Firestore.firestore()
            try db.collection("products").document(product.id).setData(from: product) { error in
                if let error = error {
                    print("❌ Lỗi khi thêm sản phẩm: \(error.localizedDescription)")
                } else {
                    print("✅ Thêm sản phẩm thành công!")
                    completion()
                }
            }
        } catch {
            print("❌ Lỗi khi encode sản phẩm: \(error.localizedDescription)")
        }
    }
}

public extension ProductGenericService {
    func resetProduct() {
        self.products = []
    }
    
    @MainActor
    func loadProducts(for category: CategoryDT) {
        self.callAPIStatus = .Loading
        if category.name == "Tất cả" {
            fetchAllProducts{ [weak self] products in
                DispatchQueue.main.async {
                    self?.products = products
                    self?.callAPIStatus = .Success
                }
            }
        } else {
            fetchProducts(for: category) { [weak self] products in
                DispatchQueue.main.async {
                    self?.products = products
                    self?.callAPIStatus = .Success
                }
            }
        }
    }
}

