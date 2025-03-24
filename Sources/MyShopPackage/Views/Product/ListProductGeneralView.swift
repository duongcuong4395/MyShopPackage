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
    @State private var column = Array(repeating: GridItem(.flexible(), spacing: 1), count: 2)
    
    
    private var actionsForCart: [CartItemAction]
    private var onActionForCart: (CartService.ProductDT, CartItemAction) -> Void
    
    private var actionsForProduct: [ProductItemAction]
    private var onActionForProduct: (ProductDT, ProductItemAction) -> Void
    
    public init(viewApplyFor: ViewApplyFor, cartService: CartService
                , products: [ProductDT]
                , actionsForCart: [CartItemAction]
                , onActionForCart: @escaping (CartService.ProductDT, CartItemAction) -> Void
                
                , actionsForProduct: [ProductItemAction]
                , onActionForProduct: @escaping (ProductDT, ProductItemAction) -> Void
    ) {
        self.cartService = cartService
        self.products = products
        self.viewApplyFor = viewApplyFor
        
        self.actionsForCart = actionsForCart
        self.onActionForCart = onActionForCart
        
        self.actionsForProduct = actionsForProduct
        self.onActionForProduct = onActionForProduct
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
                                    cartService: cartService
                                    , product: product
                                    , actions: actionsForCart
                                    , onAction: onActionForCart)
                        case .EditProduct:
                            ProductItemGenericView(product: product)
                            .padding(5)
                            .productItemOptionGenericModifier(
                                product: product
                                , actions: actionsForProduct
                                , onAction: onActionForProduct)
                        }
                    }
                }
            }
        }
    }
}

struct ProductItemOptionGenericModifier<ProductDT: ProductData>: ViewModifier {
    
    var product: ProductDT
    var actions: [ProductItemAction]
    var onAction: (ProductDT, ProductItemAction) -> Void
    
    func body(content: Content) -> some View {
        content
            .overlay {
                VStack{
                    Spacer()
                    HStack {
                        Spacer()
                        
                        ForEach(actions, id: \.self) { action in
                            Button(action: {
                                onAction(product, action)
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
                    .padding(.bottom, 60)
                    .padding(.trailing, 7)
                }
            }
    }
}

extension View {
    func productItemOptionGenericModifier<ProductDT: ProductData>(
    product: ProductDT
    , actions: [ProductItemAction]
    , onAction: @escaping (ProductDT, ProductItemAction) -> Void
    ) -> some View {
        return self.modifier(ProductItemOptionGenericModifier(
            product: product
            , actions: actions
            , onAction: onAction))
    }
}

public struct CartItemOptionGenericModifier<
    ProductDT: ProductData
        , CartService: CartServiceGeneric>: ViewModifier where CartService.ProductDT == ProductDT {
    private var cartService: CartService
    private var product: CartService.ProductDT
    private var actions: [CartItemAction]
    private var onAction: (CartService.ProductDT, CartItemAction) -> Void
    
    init(cartService: CartService
         , product: ProductDT
         , actions: [CartItemAction]
         , onAction: @escaping (ProductDT, CartItemAction) -> Void) {
        
        self.cartService = cartService
        self.product = product
        self.actions = actions
        self.onAction = onAction
    }
    
    public func body(content: Content) -> some View {
        content
            .overlay {
                VStack{
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        if let cartItem = cartService.getCartItem(form: product) {
                            HStack(spacing: 20) {
                                if let actionPlus = actions.first(where: { $0 == .increaseQuantity }) {
                                    Button(action: {
                                        onAction(product, actionPlus)
                                    }, label: {
                                        Image(systemName: actionPlus.icon)
                                            .font(.body.bold())
                                            .foregroundStyle(.green)
                                    })
                                }
                                Text("\(cartItem.quantity)")
                                    .font(.body.bold())
                                    .foregroundStyle(.black)

                                if let actionMinus = actions.first(where: { $0 == .decreaseQuantity })  {
                                    Button(action: {
                                        onAction(product, actionMinus)
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
                            if let actionPlus = actions.first(where: { $0 == .increaseQuantity }) {
                                Button(action: {
                                    onAction(product, actionPlus)
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
                    .padding(.bottom, 60)
                    .padding(.trailing, 7)
                }
            }
    }
}


extension View {
    
    func cartItemOptionGenericModifier<
        ProductDT: ProductData
            ,CartService: CartServiceGeneric > (
                                            
        cartService: CartService
        , product: CartService.ProductDT
        , actions: [CartItemAction]
        , onAction: @escaping (CartService.ProductDT, CartItemAction) -> Void) -> some View
    where CartService.ProductDT == ProductDT
    {
            
        return self.modifier(CartItemOptionGenericModifier(
            cartService: cartService
            , product: product
            , actions: actions
            , onAction: onAction) )
    }
}
