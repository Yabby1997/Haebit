//
//  UnlockButton.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct UnlockButton: View {
    @StateObject var viewModel: HaebitLightMeterViewModel

    var body: some View {
        Button(action: viewModel.didTapUnlock) { Text(.controlViewUnlockButton) }
            .font(.system(size: 18, weight: .bold, design: .monospaced))
            .foregroundStyle(.yellow)
            .shadow(radius: 5)
            .opacity(viewModel.isLocked ? 1.0 : .zero)
            .animation(.easeInOut, value: viewModel.isLocked)
    }
}
