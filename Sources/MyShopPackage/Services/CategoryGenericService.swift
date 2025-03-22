//
//  CategoryGenericService.swift
//  MyShopPackage
//
//  Created by Macbook on 22/3/25.
//

import SwiftUI
import FirebaseFirestore

public protocol CategoryGenericService: ObservableObject {
    associatedtype CategoryDT: CategoryData
    var category: CategoryDT { get set }
    var imageCloudService: ImageCloudService { get }
}

// MARK: Events for CURL product data with firebase
public extension CategoryGenericService {
    
    func deleteCategory(_ category: CategoryDT, conpletion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("categories").document(category.id).delete { error in
            if let error = error {
                print("❌ Lỗi khi xóa sản phẩm: \(error.localizedDescription)")
                conpletion(false)
            } else {
                print("✅ Xóa sản phẩm thành công!")
                conpletion(true)
            }
        }
    }
    
    func addCategory(_ category: CategoryDT, completion: @escaping () -> Void) {
        do {
            let db = Firestore.firestore()
            try db.collection("categories").document(category.id).setData(from: category) { error in
                if let error = error {
                    print("❌ Lỗi khi thêm loại sản phẩm: \(error.localizedDescription)")
                } else {
                    print("✅ Thêm loại sản phẩm thành công!")
                    completion()
                }
            }
        } catch {
            print("❌ Lỗi khi encode loại sản phẩm: \(error.localizedDescription)")
        }
    }
}


// MARK: Events for Upload/Delete Product to server(Firebase and ImageClound)
public extension CategoryGenericService {
    /// **Hàm Upload Sản Phẩm**
    func uploadCategory(completion: @escaping (Bool) -> Void) {
        guard let imageData = category.uiImage?.jpegData(compressionQuality: 0.8) else {
           completion(false)
           return
       }

        imageCloudService.uploadImage(imageData: imageData) { [weak self] imageUrl in
           guard let imageUrl = imageUrl else {
               completion(false)
               return
           }
           
            let newCategory = CategoryDT(name: (self?.category.name ?? "")
                                      , imageUrl: imageUrl)

            self?.addCategory(newCategory) {
               completion(true)
           }
       }
   }

   /// **Hàm Xóa Sản Phẩm**
    func deleteCategory(_ category: CategoryDT, completion: @escaping (Bool) -> Void) {
        imageCloudService.deleteImage(imageUrl: category.imageUrl) { [weak self] success in
           if success {
               self?.deleteCategory(category, conpletion: { isSuccess in
                   completion(isSuccess)
               })
           } else {
               completion(false)
           }
       }
   }
}
