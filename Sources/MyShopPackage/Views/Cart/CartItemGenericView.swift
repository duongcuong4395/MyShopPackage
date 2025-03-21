//
//  CartItemGenericView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public struct CartItemGenericView<CartService: CartServiceGeneric>: View {
    
    private var cartService: CartService
    private var cartItem: CartService.CartItemDT
    private var actions: [CartItemAction]
    private var onAction: (CartService.CartItemDT, CartItemAction) -> Void

    init(cartService: CartService
         , cartItem: CartService.CartItemDT
         , actions: [CartItemAction]
         , onAction: @escaping (CartService.CartItemDT, CartItemAction) -> Void) {
        self.cartService = cartService
        self.cartItem = cartItem
        self.actions = actions
        self.onAction = onAction
    }
    
    public var body: some View {
        HStack {
            ProductImageGenericView(product: cartItem.product)
                .overlay {
                    if !actions.isEmpty {
                        VStack {
                            HStack {
                                ForEach(actions, id: \.self) { action in
                                    switch action {
                                    case .remove:
                                        Image(systemName: action.icon)
                                            .font(.title2)
                                            .foregroundColor(action == .remove ? .red : .blue)
                                            .onTapGesture {
                                                onAction(cartItem, action)
                                            }
                                    default:
                                        EmptyView()
                                    }
                                }
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                }

            if actions.contains(where: { $0 == .increaseQuantity || $0 == .increaseQuantity }) {
                VStack {
                    Text(cartItem.product.name)
                    Text("\(cartItem.product.convertMoney())")
                        .font(.body.bold())
                }
                Spacer()
                CartItemOptionGenericView(service: cartService, product: cartItem.product as! CartService.ProductDT)
                    .frame(minWidth: UIScreen.main.bounds.width / 3)
                    .padding(7)
            } else {
                VStack {
                    Text(cartItem.product.name)
                    Text("\(cartItem.product.convertMoney())")
                        .font(.body.bold())
                }
                Spacer()
                Text("SL: \(cartItem.quantity)")
                    .font(.body.bold())
            }
        }
    }
}
