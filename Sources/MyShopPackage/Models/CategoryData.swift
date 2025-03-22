//
//  CategoryData.swift
//  MyShopPackage
//
//  Created by Macbook on 22/3/25.
//
import SwiftUI

public protocol CategoryData: Codable, Identifiable, Hashable, Equatable {
    var id: String { get }
    var name: String { get }
    var imageUrl: String { get set }
    var imageName: String { get }
    var xIndex: CGFloat { get }
    var uiImage: UIImage? { get set }
    
    init(name: String, imageUrl: String)
}
