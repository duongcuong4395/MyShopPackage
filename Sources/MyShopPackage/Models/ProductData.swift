//
//  ProductData.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

// Codable
public protocol ProductData: Identifiable, Hashable, ItemOptionsBuilder {
    associatedtype CategoryType: CategoryData
    var id: String { get set }
    var name: String { get set }
    var price: Double { get set }
    var imageUrl: String { get set }
    var category: CategoryType { get set }
    var uiImage: UIImage? { get set }
    
    init(name: String
         , price: Double
         , imageUrl: String
         , category: CategoryType)
}

public extension ProductData {
    
    @MainActor
    @ViewBuilder
    func getItemView(and optionsView: some View) -> some View {
        VStack {
            ProductImageGenericView(product: self)
            Spacer()
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                Text("\(convertMoney())")
                    .font(.subheadline)
            }
        }
        .overlay {
            VStack{
                Spacer()
                optionsView
                .padding(.bottom, 60)
                .padding(.trailing, 7)
            }
        }
    }
}

public extension ProductData {
    func convertMoney() -> String {
        return price.convertMoney()// (NumberFormatter.currencyFormatter.string(from: NSNumber(value: price)) ?? "0") + " đ"
    }
    
    
    
}

