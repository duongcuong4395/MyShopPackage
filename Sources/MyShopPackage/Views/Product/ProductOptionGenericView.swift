//
//  ProductOptionGenericView.swift
//  MyShopPackage
//
//  Created by Macbook on 24/3/25.
//

import SwiftUI

public enum ProductItemAction {
    case Remove
    case Edit
    case favorite

    var icon: String {
        switch self {
        case .Remove: return "trash"
        case .Edit: return "pencil"
        case .favorite: return "heart"
        }
    }
}


