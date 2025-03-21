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
    Service: CartServiceGeneric & ObservableObject
>: View where Service.ProductDT == ProductDT, Service.CartItemDT == CartItemDT {

    @ObservedObject private var service: Service
    @State private var cartItem: CartItemDT?
    private var product: ProductDT

    public init(service: Service, product: ProductDT) {
        self.service = service
        self.product = product
    }
    
    public var body: some View {
        HStack {
            Spacer()
            
            if let cartItem = service.getCartItem(form: product) {
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation {
                            service.addToCart(product)
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
                            service.removeFromCart(product, forAll: false)
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
                        service.addToCart(product)
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
    }
}
