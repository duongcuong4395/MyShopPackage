//
//  ProductItemGenericView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public struct ProductItemGenericView<
    
    ProductDT: ProductData
        , Service: CartServiceGeneric & ObservableObject>: View
where Service.ProductDT == ProductDT
{
    
    @ObservedObject private var service: Service
    private var product: ProductDT
    
    
    public init(service: Service, product: ProductDT) {
        self.service = service
        self.product = product
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
