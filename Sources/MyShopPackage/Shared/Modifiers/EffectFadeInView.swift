//
//  EffectFadeInView.swift
//  MyShopPackage
//
//  Created by Macbook on 21/3/25.
//

import SwiftUI


public enum FadeDirection {
    case bottomToTop, topToBottom, leftToRight, rightToLeft
}

public struct EffectFadeInViewModifier: ViewModifier {
    @State private var revealPercentage: CGFloat = 0.0
    let duration: Double
    let direction: FadeDirection
    let isLoop: Bool

    public func body(content: Content) -> some View {
        content
            .overlay(overlayView.mask(content))
            .onAppear {
                startAnimation()
            }
    }

    private func startAnimation() {
        withAnimation(.easeInOut(duration: duration)) {
            revealPercentage = 1.0
        }

        if isLoop {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                resetAnimation()
            }
        }
    }

    private func resetAnimation() {
        revealPercentage = 0.0
        startAnimation()
    }

    private var overlayView: LinearGradient {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: .clear, location: revealPercentage),
                .init(color: .black.opacity(0.5), location: revealPercentage)
            ]),
            startPoint: startPoint,
            endPoint: endPoint
        )
    }

    private var startPoint: UnitPoint {
        switch direction {
        case .bottomToTop: return .bottom
        case .topToBottom: return .top
        case .leftToRight: return .leading
        case .rightToLeft: return .trailing
        }
    }

    private var endPoint: UnitPoint {
        switch direction {
        case .bottomToTop: return .top
        case .topToBottom: return .bottom
        case .leftToRight: return .trailing
        case .rightToLeft: return .leading
        }
    }
}

public extension View {
    func effectFadeInView(duration: Double = 1.0, direction: FadeDirection = .bottomToTop, isLoop: Bool = false) -> some View {
        self.modifier(EffectFadeInViewModifier(duration: duration, direction: direction, isLoop: isLoop))
    }
}
