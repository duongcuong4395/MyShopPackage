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

    //@ObservedObject private var cartService: CartService
    private var products: [ProductDT]
    @State var viewApplyFor: ViewApplyFor
    
    private var positionOptionsView: (PositionView, EdgeInsets) = (.BottomTrailing, .init())
    
    private var productConfig: ProductActionConfig<ProductDT>
    private var cartConfig: CartActionConfig<ProductDT, CartService>
    
    @State private var column = Array(repeating: GridItem(.flexible(), spacing: 1), count: 2)
    
    public init(viewApplyFor: ViewApplyFor
                , positionOptionsView: (PositionView, EdgeInsets) = (.BottomTrailing, .init())
                //, cartService: CartService
                , products: [ProductDT]
                , cartConfig: CartActionConfig<ProductDT, CartService>
                , productConfig: ProductActionConfig<ProductDT>
    ) {
        //self.cartService = cartService
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
                                    product: product
                                    , config: cartConfig)
                        case .EditProduct:
                            ProductItemGenericView(product: product)
                            .padding(5)
                            .productItemOptionGenericModifier(
                                product: product
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
    public var positionView: (position: PositionView, padding: EdgeInsets) = (.BottomTrailing, .init())
    
    public init(
        positionView: (position: PositionView, padding: EdgeInsets) = (.BottomTrailing, .init()),
        actions: [ProductItemAction], onAction: @escaping (ProductDT, ProductItemAction) -> Void) {
        self.positionView = positionView
        self.actions = actions
        self.onAction = onAction
    }
}

public struct CartActionConfig<ProductDT: ProductData, CartService: CartServiceGeneric> where CartService.ProductDT == ProductDT {
    public let cartService: CartService
    public let actions: [CartItemAction]
    public let onAction: (ProductDT, CartItemAction) -> Void
    public var positionView: (position: PositionView, padding: EdgeInsets) = (.BottomTrailing, .init())
    
    public init(
        cartService: CartService
        , positionView: (position: PositionView, padding: EdgeInsets) = (.BottomTrailing, .init())
        ,actions: [CartItemAction]
        , onAction: @escaping (ProductDT, CartItemAction) -> Void) {
            
        self.cartService = cartService
        self.positionView = positionView
        self.actions = actions
        self.onAction = onAction
    }
}

struct ProductItemOptionGenericModifier<ProductDT: ProductData>: ViewModifier {
    private var spacingItems: CGFloat
    private var product: ProductDT
    private var config: ProductActionConfig<ProductDT>
    
    init(spacingItems: CGFloat = 20, product: ProductDT
        , config: ProductActionConfig<ProductDT>) {
            
        self.spacingItems = spacingItems
        self.product = product
        self.config = config
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                PositionedOverlay(
                    position: config.positionView.position
                    , padding: config.positionView.padding
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
        spacingItems: CGFloat = 20
        , product: ProductDT
        , config: ProductActionConfig<ProductDT>
    ) -> some View {
        return self.modifier(ProductItemOptionGenericModifier(
            spacingItems: spacingItems
            , product: product
            , config: config))
    }
}

public struct CartItemOptionGenericModifier<
    ProductDT: ProductData
        , CartService: CartServiceGeneric>: ViewModifier where CartService.ProductDT == ProductDT {
    
    private var product: CartService.ProductDT
    private var config: CartActionConfig<ProductDT, CartService>
    
    init(product: ProductDT
        , config: CartActionConfig<ProductDT, CartService>) {
            
        self.product = product
        self.config = config
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                PositionedOverlay(
                    position: config.positionView.position
                    , padding: config.positionView.padding
                    ) {
                    MainView
                }
            }
    }
    
    @ViewBuilder
    var MainView: some View {
        HStack(spacing: 20) {
            if let cartItem = config.cartService.getCartItem(form: product) {
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
        product: CartService.ProductDT
        , config: CartActionConfig<ProductDT, CartService>) -> some View
    where CartService.ProductDT == ProductDT {
            
        return self.modifier(CartItemOptionGenericModifier(
            product: product
            , config: config) )
    }
}



