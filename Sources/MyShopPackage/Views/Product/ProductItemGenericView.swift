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
        if #available(iOS 17.0, *) {
            product.getItemView(and: optionsView)
                .onAppear{
                    cartItem = service.getCartItem(form: product)
                }
                .onChange(of: service.cartItems) { oldValue, newValue in
                    cartItem = service.getCartItem(form: product)
                }
        } else {
            // Fallback on earlier versions
        }
        
        /*
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
        */
    }
    
    @ViewBuilder
    var optionsView: some View {
        
        HStack {
            Spacer()
            
            //if let cartItem = service.getCartItem(form: product) {
            if let cartItem = cartItem {
                HStack(spacing: 20) {
                    product.getBtnPlusProduct(with: .Button, with: self)
                        .font(.body.bold())
                        .foregroundStyle(.green)
                    

                    Text("\(cartItem.quantity)")
                        .font(.body.bold())
                        .foregroundStyle(.black)

                    product.getBtnMinusProduct(with: .Button, with: self)
                        .font(.body.bold())
                        .foregroundStyle(.green)
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






extension ProductItemGenericView {
    //@MainActor
    public func plusProduct<T>(for model: T) where T : Decodable {
        guard let model = model as? ProductDT else { return }
        service.addToCart(model)
    }
    
    public func minusProduct<T>(for model: T) where T : Decodable {
        guard let model = model as? ProductDT else { return }
        service.removeFromCart(model, forAll: false)
    }
}
