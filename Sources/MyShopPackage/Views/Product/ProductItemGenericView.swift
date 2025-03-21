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
    
    public init(service: Service, product: ProductDT) {
        self.service = service
        self.product = product
    }
    
    public var body: some View {
        product.getItemView(and: EmptyView())
        
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
        .overlay {
            VStack{
               Spacer()
               
               .padding(.bottom, 60)
               .padding(.trailing, 7)
            }
        }*/
    }
    
    var optionsView: some View {
        
        HStack {
            Spacer()
            
            if let cartItem = service.getCartItem(form: product) {
                HStack(spacing: 20) {
                    product.getBtnPlusProduct(with: .Button, with: self)
                        .font(.body.bold())
                        .foregroundStyle(.green)
                    /*
                    Button(action: {
                        withAnimation {
                            service.addToCart(product)
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .font(.body.bold())
                            .foregroundStyle(.green)
                    })
                    */

                    Text("\(cartItem.quantity)")
                        .font(.body.bold())
                        .foregroundStyle(.black)

                    product.getBtnMinusProduct(with: .Button, with: self)
                        .font(.body.bold())
                        .foregroundStyle(.green)
                    /*
                    Button(action: {
                        withAnimation {
                            service.removeFromCart(product, forAll: false)
                        }
                    }, label: {
                        Image(systemName: "minus")
                            .font(.body.bold())
                            .foregroundStyle(.green)
                    })
                    */
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



