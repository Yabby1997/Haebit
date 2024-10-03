//
//  ShutterButton.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels
import HaebitUI

struct ShutterButton: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies
    
    var body: some View {
        HaebitShutterButton(
            shutterSpeed: Binding(
                get: { UInt64(viewModel.shutterSpeed.value * 1_000_000_000) },
                set: { _ in }
            )
        ) {
            viewModel.didTapShutter()
        }
        .environmentObject(dependencies.shutterButtonDependency)
    }
}
