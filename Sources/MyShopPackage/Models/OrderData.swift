//
//  OrderData.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

public enum OrderStatus: String, Codable {
    case pending = "Chờ xử lý"
    case confirmed = "Đã xác nhận"
    case cancelled = "Đã hủy"
    
    @MainActor
    @ViewBuilder
    public  func titleChangeStatusView(changeToPending: @escaping () -> Void
                           , changeToConfirmed: @escaping () -> Void
                           , changeToCanel: @escaping () -> Void
    ) -> some View {
        VStack(spacing: 5) {
            HStack(spacing: 0) {
                Text("Đơn hàng này ")
                    .font(.caption)
                Text("\(self.rawValue)")
                    .font(.caption.bold())
                    .foregroundColor(self == .pending ? .orange : (self == .confirmed ? .green : .red))
                Spacer()
            }
            HStack {
                Text("Bạn muốn chuyển qua ")
                    .font(.caption)
                switch self {
                case .pending:
                    Text("Đã xác nhận")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                        .onTapGesture(perform: changeToConfirmed)
                    Text(" hay ")
                        .font(.caption)
                    Text("Đã hủy.")
                        .font(.caption.bold())
                        .foregroundColor(.red)
                        .onTapGesture(perform: changeToCanel)
                case .confirmed:
                    Text("Chờ xử lý")
                        .font(.caption.bold())
                        .foregroundColor(.orange)
                        .onTapGesture(perform: changeToPending)
                    Text(" hay ")
                        .font(.caption)
                    Text("Đã hủy.")
                        .font(.caption.bold())
                        .foregroundColor(.red)
                        .onTapGesture(perform: changeToCanel)
                case .cancelled:
                    
                    Text("Chờ xử lý")
                        .font(.caption.bold())
                        .foregroundColor(.orange)
                        .onTapGesture(perform: changeToPending)
                    Text(" hay ")
                        .font(.caption)
                    Text("Đã xác nhận.")
                        .font(.caption.bold())
                        .foregroundColor(.green)
                        .onTapGesture(perform: changeToConfirmed)
                }
                Spacer()
            }
        }
        
        
    }
}

public protocol OrderData: Codable, Identifiable {
    associatedtype CartItemType: CartItemData
    var id: String? { get set }
    var userId: String { get set }
    var items: [CartItemType] { get set }
    var totalAmount: Double { get set }
    var timestamp: Date { get set }
    var status: OrderStatus {get set}
    
    init(userId: String, items: [CartItemType], totalAmount: Double, timestamp: Date)
}

public protocol CartItemData: Codable, Identifiable, Equatable, Hashable {
    associatedtype ProductType: ProductData
    var id: String { get }
    var product: ProductType { get set}
    var quantity: Int { get set }
    
    init (product: ProductType, quantity: Int)
}

public protocol ProductData: Codable, Identifiable, Hashable {
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
    func convertMoney() -> String {
        return price.convertMoney()// (NumberFormatter.currencyFormatter.string(from: NSNumber(value: price)) ?? "0") + " đ"
    }
}

public protocol CategoryData: Codable, Identifiable, Hashable {
    var id: String { get }
    var name: String { get }
    var imageName: String { get }
    var xIndex: CGFloat { get }
}

// MARK: Extension For Logic
public extension Double {
    func convertMoney() -> String {
        return (NumberFormatter.currencyFormatter.string(from: NSNumber(value: self)) ?? "0") + " đ"
    }
}

public extension NumberFormatter {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // Hiển thị theo kiểu 123.456.789
        formatter.maximumFractionDigits = 0 // Không có số thập phân
        formatter.groupingSeparator = "." // Dùng dấu chấm phân cách hàng nghìn
        return formatter
    }()
}

