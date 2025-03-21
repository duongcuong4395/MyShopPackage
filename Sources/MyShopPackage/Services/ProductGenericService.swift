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
    var imageCloudService: ImageCloudService { get }
}


// MARK: Events for CURL product data with firebase
public extension ProductGenericService {
    
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

// MARK: Events for Upload/Delete Product to server(Firebase and ImageClound)
public extension ProductGenericService {
    /// **Hàm Upload Sản Phẩm**
    func uploadProduct(completion: @escaping (Bool) -> Void) {
        guard let imageData = product.uiImage?.jpegData(compressionQuality: 0.8) else {
           completion(false)
           return
       }

        imageCloudService.uploadImage(imageData: imageData) { [weak self] imageUrl in
           guard let imageUrl = imageUrl, let priceValue = self?.product.price else {
               completion(false)
               return
           }
           
           let newProduct = ProductDT(name: (self?.product.name ?? "")
                                      , price: priceValue
                                      , imageUrl: imageUrl
                                      , category: (self?.product.category ?? .init()))

           self?.addProduct(newProduct) {
               completion(true)
           }
       }
   }

   /// **Hàm Xóa Sản Phẩm**
    func deleteProduct(_ product: ProductDT, completion: @escaping (Bool) -> Void) {
        imageCloudService.deleteImage(imageUrl: product.imageUrl) { [weak self] success in
           if success {
               self?.deleteProduct(product, conpletion: { isSuccess in
                   completion(isSuccess)
               })
           } else {
               completion(false)
           }
       }
   }
}


