//
//  CartItem.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public enum CartItemAction {
    case remove
    case increaseQuantity
    case decreaseQuantity
    case favorite

    var icon: String {
        switch self {
        case .remove: return "trash"
        case .increaseQuantity: return "plus"
        case .decreaseQuantity: return "minus"
        case .favorite: return "heart"
        }
    }
}
