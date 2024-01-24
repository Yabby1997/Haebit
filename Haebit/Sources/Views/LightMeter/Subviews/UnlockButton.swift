//
//  UnlockButton.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct UnlockButton<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel

    var body: some View {
        Button(action: viewModel.didTapUnlock) { Text(.lightMeterControlViewUnlockButton) }
            .opacity(viewModel.isLocked ? 1.0 : .zero)
            .font(.system(size: 18, weight: .bold, design: .monospaced))
            .foregroundStyle(.yellow)
            .shadow(radius: 5)
            .animation(.easeInOut, value: viewModel.isLocked)
    }
}
