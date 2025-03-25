//
//  ProductItemGenericView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public struct ProductItemGenericView<ProductDT: ProductData>: View {
    private var product: ProductDT
    
    private var isLayoutVertical: Bool
    
    public init(product: ProductDT
    , isLayoutVertical: Bool = true) {
        self.product = product
        self.isLayoutVertical = isLayoutVertical
    }
    
    public var body: some View {
        if isLayoutVertical {
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
        } else {
            HStack {
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
}
