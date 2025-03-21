//
//  ImageCloudService.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

protocol ImageCloudService {
    func uploadImage(imageData: Data, completion: @escaping (String?) -> Void)
    func deleteImage(imageUrl: String, completion: @escaping (Bool) -> Void)
}

extension ImageCloudService {
    /// Trích xuất `publicId` từ URL Cloudinary
    func extractPublicId(from url: String) -> String? {
        let components = url.components(separatedBy: "/")
        guard let lastComponent = components.last else { return nil }
        let publicId = lastComponent.components(separatedBy: ".").first
        return publicId
    }
}
