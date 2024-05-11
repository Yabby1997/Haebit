//
//  BackgroundGradient.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct BackgroundGradient: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    .black,
                    .black.opacity(0.9),
                    .black.opacity(0.7),
                    .black.opacity(0.3),
                    .clear
                ]
            ),
            startPoint: .bottom,
            endPoint: .init(x: 0.5, y: .zero)
        )
        .ignoresSafeArea()
        .allowsHitTesting(true)
    }
}
