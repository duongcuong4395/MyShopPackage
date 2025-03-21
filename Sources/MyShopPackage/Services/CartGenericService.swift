//
//  CartGenericService.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI
import FirebaseFirestore

public protocol CartServiceGeneric: ObservableObject
where OrderDT.CartItemType == CartItemDT
      , CategoryDT == CartItemDT.ProductType.CategoryType
{
    associatedtype ProductDT: ProductData
    associatedtype CartItemDT: CartItemData
    associatedtype CategoryDT: CategoryData
    associatedtype OrderDT: OrderData
    
    var cartItems: [CartItemDT] { get set }
}

// MARK: More properties
public extension CartServiceGeneric {
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    var uniqueCategories: [CategoryDT] {
        Set(cartItems.map { $0.product.category }).sorted { $0.name < $1.name }
    }
   
   var categoryCount: Int {
       uniqueCategories.count
   }
    
    var totalAmount: Double {
        cartItems.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
}

public extension CartServiceGeneric {
    func checkout(userId: String, completion: @escaping (Bool) -> Void) {
        let order = OrderDT(userId: userId, items: self.cartItems, totalAmount: totalAmount, timestamp: Date())

        let db = Firestore.firestore()
        do {
            try db.collection("orders").addDocument(from: order)
            
            completion(true)
        } catch {
            print("❌ Lỗi khi gửi đơn hàng: \(error.localizedDescription)")
            completion(false)
        }
    }
}

public extension CartServiceGeneric {
    func getCartItem(form product: ProductDT) -> CartItemDT? {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            return cartItems[index]
        }
        return nil
    }
    
    func addToCart(_ product: ProductDT) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
        } else {
            let newItem = CartItemDT(product: product as! Self.CartItemDT.ProductType, quantity: 1)
            cartItems.append(newItem)
        }
    }
    
    func removeFromCart(_ product: ProductDT, forAll: Bool = false) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            if forAll {
                cartItems.remove(at: index)
            } else {
                if cartItems[index].quantity > 1 {
                    cartItems[index].quantity -= 1
                } else {
                    cartItems.remove(at: index)
                }
            }
        }
    }
    
    func resetCart() {
        self.cartItems.removeAll()
    }
}
