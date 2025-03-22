//
//  CategoryData.swift
//  MyShopPackage
//
//  Created by Macbook on 22/3/25.
//

public protocol CategoryData: Codable, Identifiable, Hashable, Equatable {
    var id: String { get }
    var name: String { get }
    var imageName: String { get }
    var xIndex: CGFloat { get }
    
    init()
}
