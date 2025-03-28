//
//  ListProductGenericService.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI
import FirebaseFirestore

public protocol ListProductGenericService: ObservableObject {
    associatedtype ProductDT: ProductData
    associatedtype CategoryDT: CategoryData
    
    var products: [ProductDT] { get set }
    var callAPIStatus: CallAPIStatus { get set }
}

// MARK: Events with List Product on View
public extension ListProductGenericService {
    func resetProduct() {
        self.products = []
    }
    
    @MainActor
    func loadProducts(for category: CategoryDT) {
        self.callAPIStatus = .Loading
        if category.name == "Tất Cả" {
            fetchAllProducts{ [weak self] products in
                
                
                DispatchQueue.main.async {
                    self?.products = products.sorted(by: { $0.category.name < $1.category.name })
                    self?.callAPIStatus = .Success
                }
            }
        } else {
            fetchProducts(for: category) { [weak self] products in
                DispatchQueue.main.async {
                    self?.products = products.sorted(by: { $0.category.name < $1.category.name })
                    self?.callAPIStatus = .Success
                }
            }
        }
    }
    
    func loadListProducts(for category: CategoryDT, completion: @escaping([ProductDT]) -> Void) {
        self.callAPIStatus = .Loading
        if category.name.lowercased() == "tất cả" {
            fetchAllProducts{ products in
                self.callAPIStatus = .Success
                completion(products)
            }
        } else {
            fetchProducts(for: category) { products in
                self.callAPIStatus = .Success
                completion(products)
            }
        }
    }
}

public extension ListProductGenericService {
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
                print("=== fetchAllProducts", products.count)
                completion(products)
            }
    }
    
    func fetchProducts(for category: CategoryDT
                       , completion: @escaping ([ProductDT]) -> Void) {
        let db = Firestore.firestore()
        db.collection("products")
            .whereField("category.id", isEqualTo: category.id)
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
}
