//
//  ListProductGeneralView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI



public struct ListProductGeneralView<
    ProductDT: ProductData,
    CartService: CartServiceGeneric & ObservableObject>: View
        where CartService.ProductDT == ProductDT {

    @ObservedObject private var cartService: CartService
    private var products: [ProductDT]
    @State var viewApplyFor: ViewApplyFor
    @State private var column = Array(repeating: GridItem(.flexible(), spacing: 1), count: 2)
    
    public init(viewApplyFor: ViewApplyFor, cartService: CartService, products: [ProductDT]) {
        self.cartService = cartService
        self.products = products
        self.viewApplyFor = viewApplyFor
    }
    
    public var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: column, spacing: 10) {
                    ForEach(products, id: \.id) { product in
                        ProductItemGenericView(product: product)
                        .padding(5)
                        .overlay {
                            if viewApplyFor == .AddProduct {
                                VStack{
                                    Spacer()
                                    CartItemOptionGenericView(cartService: cartService, product: product)
                                    
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
    
}


