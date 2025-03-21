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
}
