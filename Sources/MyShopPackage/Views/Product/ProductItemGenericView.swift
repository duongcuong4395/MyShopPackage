//
//  ProductItemGenericView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public struct ProductItemGenericView<ProductDT: ProductData>: View {
    private var product: ProductDT
    
    public init(product: ProductDT) {
        self.product = product
    }
    
    public var body: some View {
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
    }
}

public struct ProductImageGenericView<ProductDT: ProductData>: View {
    private var product: ProductDT
    @State private var retryCount = 0
    @State private var imageURL: URL?
    
    public init(product: ProductDT) {
        self.product = product
        self._imageURL = State(initialValue: URL(string: product.imageUrl))
    }
    
    public var body: some View {
        AsyncImage(url: imageURL) { phase in
            switch phase {
            case .empty:
                VStack {
                    Image(product.category.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .effectOpenCloseView()
                        .effectFadeInView(duration: 1, isLoop: true)
                    
                }
                
            case .success(let image):
                image.resizable().scaledToFit()
                    .clipShape(.rect(cornerRadius: 15))
                    .effectFadeInView(duration: 1, isLoop:false)
                    .effectOpenCloseView()
            case .failure(_):
                errorView()
                    .onAppear {
                        retryLoadImage()  // 🚀 Thử lại khi vào View
                    }
            @unknown default:
                VStack {
                    Image(product.category.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .effectOpenCloseView()
                        .effectFadeInView(duration: 1, isLoop: true)
                    
                }
            }
            
        }
    }
    
    // 🚀 Hàm thử tải lại ảnh
   private func retryLoadImage() {
       if retryCount < 3 {
           retryCount += 1
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) { // ⏳ Đợi 1 giây rồi thử lại
               imageURL = URL(string: product.imageUrl + "?retry=\(retryCount)") // 🌀 Thay đổi URL để AsyncImage tải lại
           }
       }
   }

   // ❌ View khi lỗi tải ảnh
   private func errorView() -> some View {
       Image(systemName: "exclamationmark.triangle.fill")
           .resizable()
           .scaledToFit()
           .frame(width: 50, height: 50)
           .foregroundColor(.red)
   }
}

