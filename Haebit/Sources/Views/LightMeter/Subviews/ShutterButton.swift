//
//  ShutterButton.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct ShutterButton<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies
    
    var body: some View {
        HaebitShutterButton(
            shutterSpeed: Binding(
                get: { UInt64(viewModel.shutterSpeed.value * 1_000_000_000) },
                set: { _ in }
            )
        ) {
            viewModel.didTapShutter()
        } completion: {
            viewModel.didCloseShutter()
        }
        .disabled(viewModel.isCapturing)
        .environmentObject(dependencies.shutterButtonDependency)
    }
}
