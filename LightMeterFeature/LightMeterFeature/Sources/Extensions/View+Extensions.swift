//
//  View+Extensions.swift
//  LightMeterFeature
//
//  Created by Seunghun on 6/3/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI

extension ProposedViewSize {
    var rotated: ProposedViewSize {
        .init(width: height, height: width)
    }
}

extension CGSize {
    var rotated: CGSize {
        .init(width: height, height: width)
    }
}

private struct Rotated: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        guard let size = subviews.first?.sizeThatFits(proposal.rotated) else { return .zero }
        return size.rotated
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        subviews.first?.place(
            at: .init(x: bounds.midX, y: bounds.midY),
            anchor: .center,
            proposal: proposal.rotated
        )
    }
}

struct RotateClockwise: ViewModifier {
    func body(content: Content) -> some View {
        Rotated {
            content
                .rotationEffect(.degrees(90))
        }
    }
}

struct RotateAnticlockwise: ViewModifier {
    func body(content: Content) -> some View {
        Rotated {
            content
                .rotationEffect(.degrees(-90))
        }
    }
}

extension View {
    func rotateClockwise() -> some View {
        modifier(RotateClockwise())
    }
    
    func rotateAnticlockwise() -> some View {
        modifier(RotateAnticlockwise())
    }
}
