//
//  EffectOpenCloseView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI

struct EffectOpenCloseModifier: ViewModifier {
    @State private var isVisible: Bool = false
    
    func body(content: Content) -> some View {
        content
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.8)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    isVisible = true
                }
            }
            .onDisappear {
                withAnimation(.easeIn(duration: 0.3)) {
                    isVisible = false
                }
            }
    }
}

extension View {
    func effectOpenCloseView() -> some View {
        self.modifier(EffectOpenCloseModifier())
    }
}
