//
//  ListProductGeneralView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public struct ListProductGeneralView<
    ProductDT: ProductData,
      Service: CartServiceGeneric & ObservableObject>: View
        where Service.ProductDT == ProductDT {

    @ObservedObject private var service: Service
    private var products: [ProductDT]
    @State private var column = Array(repeating: GridItem(.flexible(), spacing: 1), count: 2)
    
    public init(service: Service, products: [ProductDT]) {
        self.service = service
        self.products = products
    }
    
    public var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: column, spacing: 10) {
                    ForEach(products, id: \.id) { product in
                        ProductItemGenericView(product: product)
                        .padding(5)
                        .overlay {
                            VStack{
                                Spacer()
                                CartItemOptionGenericView(service: service, product: product)
                                .padding(.bottom, 60)
                                .padding(.trailing, 7)
                            }
                        }
                    }
                }
            }
        }
    }
}
