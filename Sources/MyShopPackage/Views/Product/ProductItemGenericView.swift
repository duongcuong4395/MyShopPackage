//
//  ProductItemGenericView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public struct ProductItemGenericView<
    
    ProductDT: ProductData
        , Service: CartServiceGeneric & ObservableObject>: View, @preconcurrency ItemDelegate
where Service.ProductDT == ProductDT
{
    
    @ObservedObject private var service: Service
    private var product: ProductDT
    @State private var cartItem: Service.CartItemDT?
    
    public init(service: Service, product: ProductDT) {
        self.service = service
        self.product = product
        
        self._cartItem = State(initialValue: service.getCartItem(form: product))
    }
    
    public var body: some View {
        VStack {
            ProductImageGenericView(product: product)
            Spacer()
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("\(product.convertMoney())")
                    .font(.subheadline)
            }
        }
        .padding(5)
    }
}
