//
//  CategoryData.swift
//  MyShopPackage
//
//  Created by Macbook on 22/3/25.
//
import SwiftUI

public protocol CategoryData: Codable, Identifiable, Hashable, Equatable {
    var id: String { get }
    var name: String { get set }
    var imageUrl: String { get set }
    
    init(name: String, imageUrl: String)
}
