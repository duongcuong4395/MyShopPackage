//
//  CartItemOptionGenericView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public struct CartItemOptionGenericView<
    ProductDT: ProductData,
    CartItemDT: CartItemData,
    CartService: CartServiceGeneric & ObservableObject
>: View where CartService.ProductDT == ProductDT, CartService.CartItemDT == CartItemDT {

    @ObservedObject private var cartService: CartService
    @State private var cartItem: CartItemDT?
    private var product: ProductDT

    public init(cartService: CartService, product: ProductDT) {
        self.cartService = cartService
        self.product = product
    }
    
    public var body: some View {
        HStack {
            Spacer()
            
            if let cartItem = cartService.getCartItem(form: product) {
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation {
                            cartService.addToCart(product)
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .font(.body.bold())
                            .foregroundStyle(.green)
                    })

                    Text("\(cartItem.quantity)")
                        .font(.body.bold())
                        .foregroundStyle(.black)

                    Button(action: {
                        withAnimation {
                            cartService.removeFromCart(product, forAll: false)
                        }
                    }, label: {
                        Image(systemName: "minus")
                            .font(.body.bold())
                            .foregroundStyle(.green)
                    })
                }
                .padding(3)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            } else {
                Button(action: {
                    withAnimation {
                        cartService.addToCart(product)
                    }
                }, label: {
                    Image(systemName: "plus")
                        .font(.body.bold())
                        .foregroundStyle(.white)
                        .padding(3)
                        .background(.green)
                        .clipShape(Circle())
                })
            }
        }
        .shadow(color: .green, radius: 5, x: 5, y: 5)
    }
}
