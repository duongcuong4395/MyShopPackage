//
//  ListProductGeneralView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI



public struct ListProductGeneralView<
    ProductDT: ProductData,
    CartService: CartServiceGeneric & ObservableObject>: View
        where CartService.ProductDT == ProductDT {

    @ObservedObject private var cartService: CartService
    private var products: [ProductDT]
    @State var viewApplyFor: ViewApplyFor
    
    private var positionOptionsView: (PositionView, EdgeInsets) = (.BottomTrailing, .init())
    
    private var cartConfig: CartActionConfig<ProductDT>
    private var productConfig: ProductActionConfig<ProductDT>
    
    @State private var column = Array(repeating: GridItem(.flexible(), spacing: 1), count: 2)
    
    public init(viewApplyFor: ViewApplyFor
                , cartService: CartService
                , products: [ProductDT]
                , positionOptionsView: (PositionView, EdgeInsets) = (.BottomTrailing, .init())
                , cartConfig: CartActionConfig<ProductDT>
                , productConfig: ProductActionConfig<ProductDT>
    ) {
        self.cartService = cartService
        self.products = products
        self.viewApplyFor = viewApplyFor
        
        self.positionOptionsView = positionOptionsView
        
        self.cartConfig = cartConfig
        
        self.productConfig = productConfig
    }
    
    public var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: column, spacing: 10) {
                    ForEach(products, id: \.id) { product in
                        switch viewApplyFor {
                        case .BuyProduct:
                            ProductItemGenericView(product: product)
                                .padding(5)
                                .cartItemOptionGenericModifier(
                                    positionView: positionOptionsView
                                    , cartService: cartService
                                    , product: product
                                    , config: cartConfig)
                        case .EditProduct:
                            ProductItemGenericView(product: product)
                            .padding(5)
                            .productItemOptionGenericModifier(
                                positionView: positionOptionsView
                                , product: product
                                , config: productConfig)
                        }
                    }
                }
            }
        }
    }
}

public struct ProductActionConfig<ProductDT: ProductData> {
    public let actions: [ProductItemAction]
    public let onAction: (ProductDT, ProductItemAction) -> Void
    
    public init(actions: [ProductItemAction], onAction: @escaping (ProductDT, ProductItemAction) -> Void) {
        self.actions = actions
        self.onAction = onAction
    }
}

public struct CartActionConfig<ProductDT: ProductData> {
    public let actions: [CartItemAction]
    public let onAction: (ProductDT, CartItemAction) -> Void
    
    public init(actions: [CartItemAction], onAction: @escaping (ProductDT, CartItemAction) -> Void) {
        self.actions = actions
        self.onAction = onAction
    }
}

struct ProductItemOptionGenericModifier<ProductDT: ProductData>: ViewModifier {
    
    private var positionView: (position: PositionView, padding: EdgeInsets) = (.BottomTrailing, .init())
    private var spacingItems: CGFloat
    private var product: ProductDT
    private var config: ProductActionConfig<ProductDT>
    
    init(
        positionView: (PositionView, EdgeInsets) = (.BottomTrailing, .init())
        , spacingItems: CGFloat = 20, product: ProductDT
        , config: ProductActionConfig<ProductDT>) {
            
        self.positionView = positionView
        self.spacingItems = spacingItems
        self.product = product
        self.config = config
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                PositionedOverlay(
                    position: positionView.position
                    , padding: positionView.padding
                    ) {
                    MainView
                }
            }
    }
    
    @ViewBuilder
    var MainView : some View {
        HStack {
            ForEach(config.actions, id: \.self) { action in
                Button(action: {
                    config.onAction(product, action)
                }, label: {
                    Image(systemName: action.icon)
                        .font(.body.bold())
                        .foregroundStyle(.white)
                        .padding(3)
                        .background(.green)
                        .clipShape(Circle())
                    
                })
                .shadow(color: .green, radius: 5, x: 5, y: 5)
            }
        }
        
    }
}

public extension View {
    func productItemOptionGenericModifier<ProductDT: ProductData>(
        positionView: (PositionView, EdgeInsets) = (.BottomTrailing, .init())
        , spacingItems: CGFloat = 20
        , product: ProductDT
        , config: ProductActionConfig<ProductDT>
    ) -> some View {
        return self.modifier(ProductItemOptionGenericModifier(
            positionView: positionView
            , spacingItems: spacingItems
            , product: product
            , config: config))
    }
}

public struct CartItemOptionGenericModifier<
    ProductDT: ProductData
        , CartService: CartServiceGeneric>: ViewModifier where CartService.ProductDT == ProductDT {
    
    private var positionView: (position: PositionView, padding: EdgeInsets) = (.BottomTrailing, .init())
    private var cartService: CartService
    private var product: CartService.ProductDT
    private var config: CartActionConfig<ProductDT>
    
    init(
        positionView: (PositionView, EdgeInsets) = (.BottomTrailing, .init())
        , cartService: CartService
        , product: ProductDT
        , config: CartActionConfig<ProductDT>) {
            
        self.positionView = positionView
        self.cartService = cartService
        self.product = product
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                PositionedOverlay(
                    position: positionView.position
                    , padding: positionView.padding
                    ) {
                    MainView
                }
            }
    }
    
    @ViewBuilder
    var MainView: some View {
        HStack(spacing: 20) {
            if let cartItem = cartService.getCartItem(form: product) {
                HStack(spacing: 20) {
                    if let actionPlus = config.actions.first(where: { $0 == .increaseQuantity }) {
                        Button(action: {
                            config.onAction(product, actionPlus)
                        }, label: {
                            Image(systemName: actionPlus.icon)
                                .font(.body.bold())
                                .foregroundStyle(.green)
                        })
                    }
                    Text("\(cartItem.quantity)")
                        .font(.body.bold())
                        .foregroundStyle(.black)

                    if let actionMinus = config.actions.first(where: { $0 == .decreaseQuantity })  {
                        Button(action: {
                            config.onAction(product, actionMinus)
                        }, label: {
                            Image(systemName: actionMinus.icon)
                                .font(.body.bold())
                                .foregroundStyle(.green)
                        })
                    }
                    
                }
                .padding(3)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            } else {
                if let actionPlus = config.actions.first(where: { $0 == .increaseQuantity }) {
                    Button(action: {
                        config.onAction(product, actionPlus)
                    }, label: {
                        Image(systemName: actionPlus.icon)
                            .font(.body.bold())
                            .foregroundStyle(.white)
                            .padding(3)
                            .background(.green)
                            .clipShape(Circle())
                    })
                }
            }
        }
        .shadow(color: .green, radius: 5, x: 5, y: 5)
    }
}


public extension View {
    
    func cartItemOptionGenericModifier<ProductDT: ProductData, CartService: CartServiceGeneric > (
        positionView: (PositionView, EdgeInsets) = (.BottomTrailing, .init())
        , cartService: CartService
        , product: CartService.ProductDT
        , config: CartActionConfig<ProductDT>) -> some View
    where CartService.ProductDT == ProductDT {
            
        return self.modifier(CartItemOptionGenericModifier(
            positionView: positionView
            , cartService: cartService
            , product: product
            , config: config) )
    }
}



