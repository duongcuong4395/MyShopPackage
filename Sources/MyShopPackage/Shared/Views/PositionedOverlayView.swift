//
//  PositionedOverlayView.swift
//  MyShopPackage
//
//  Created by Macbook on 25/3/25.
//

import SwiftUI

public enum PositionView {
    case TopTrailing
    case TopLeading
    case BottomLeading
    case BottomTrailing
}

struct PositionedOverlay<Content: View>: View {
    let position: PositionView
    let padding: EdgeInsets
    let content: Content

    init(position: PositionView
         , padding: EdgeInsets = EdgeInsets()
         , @ViewBuilder content: () -> Content) {
        self.position = position
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        VStack {
            if position == .TopLeading || position == .TopTrailing {
                HStack {
                    if position == .TopLeading { content }
                    Spacer()
                    if position == .TopTrailing { content }
                }
                .padding(padding)
                Spacer()
            } else {
                Spacer()
                HStack {
                    if position == .BottomLeading { content }
                    Spacer()
                    if position == .BottomTrailing { content }
                }
                .padding(padding)
            }
        }
    }
}


