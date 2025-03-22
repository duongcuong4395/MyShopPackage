//
//  CartItemSelectedGenericView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public struct CartItemSelectedGenericView<CategoryDT: CategoryData>: View {
    var uniqueCategories: [CategoryDT]
    var categoryItemCount: [CategoryDT: Int]
    var totalPrice: Double
    
    var onCancel: () -> Void
    var onOrder: () -> Void
    
    public init(uniqueCategories: [CategoryDT]
         , categoryItemCount: [CategoryDT : Int]
         , totalPrice: Double
         , onCancel: @escaping () -> Void
         , onOrder: @escaping () -> Void) {
        self.uniqueCategories = uniqueCategories
        self.categoryItemCount = categoryItemCount
        self.totalPrice = totalPrice
        self.onCancel = onCancel
        self.onOrder = onOrder
    }
    
    public var body: some View {
        HStack {
            ForEach(Array(uniqueCategories.enumerated()), id: \.element.id) { index, cate in
                AsyncImage(url: URL(string: cate.imageUrl)) { image in
                    image
                        .resizable()
                        .padding(5)
                        .clipShape(Circle())
                        .frame(width: 35, height: 35)
                        .overlay {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("\(categoryItemCount[cate] ?? 0)")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)
                                        .padding(2)
                                        .clipShape(Circle())
                                        .background(.red)
                                    
                                }
                                Spacer()
                            }
                            
                        }
                } placeholder: {
                    VStack {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                    }
                }
                /*
                Image(cate.imageName)
                    .resizable()
                    .padding(5)
                    .clipShape(Circle())
                    .frame(width: 35, height: 35)
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                Text("\(categoryItemCount[cate] ?? 0)")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)
                                    .padding(2)
                                    .clipShape(Circle())
                                    .background(.red)
                                
                            }
                            Spacer()
                        }
                        
                    }
                */
            }
            
            Spacer()
            HStack {
                Text("\(totalPrice.convertMoney())")
                    .font(.body.bold())
                Button(action: {
                    onOrder()
                }, label: {
                    Image(systemName: "dollarsign.circle")
                        .font(.title2.bold())
                        .foregroundStyle(.yellow)
                })
            }
            .foregroundStyle(.white)
            .padding(.trailing, 10)
        }
        .padding(7)
        .background(.green, in: RoundedRectangle(cornerRadius: 50, style: .continuous))
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
