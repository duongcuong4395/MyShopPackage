//
//  ListCategoryGenericService.swift
//  MyShopPackage
//
//  Created by Macbook on 22/3/25.
//

import SwiftUI
import FirebaseFirestore

public protocol ListCategoryGenericService: ObservableObject {
    associatedtype CategoryDT: CategoryData
    var categories: [CategoryDT] { get set }
    var categorySelected: CategoryDT { get set }
}

public extension ListCategoryGenericService {
    func fetchAllCategory(completion: @escaping ([CategoryDT]) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("categories")
            .getDocuments { snapshot, error in
                guard let documents = snapshot?.documents, error == nil else {
                    completion([])
                    return
                }
                let products = documents.compactMap { doc -> CategoryDT? in
                    try? doc.data(as: CategoryDT.self)
                }
                completion(products)
            }
    }
}
