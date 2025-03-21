//
//  ProductItemGenericView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public struct ProductItemGenericView<ProductDT: ProductData>: View {
    private var product: ProductDT
    
    public init(product: ProductDT) {
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
    }
}



