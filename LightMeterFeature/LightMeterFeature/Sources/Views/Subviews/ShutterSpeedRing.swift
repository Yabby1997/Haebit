//
//  ShutterSpeedRing.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels
import HaebitUI

struct ShutterSpeedRing: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies
    
    var body: some View {
        HaebitApertureRing(selection: $viewModel.shutterSpeed, entries: $viewModel.shutterSpeedValues) { shutterSpeed in
            Text(shutterSpeed.title)
                .foregroundStyle(
                    viewModel.shutterSpeedMode
                        ? viewModel.shutterSpeed == shutterSpeed
                            ? .yellow
                            : .gray
                        : .white
                )
                .font(.system(size: 18, weight: .bold, design: .serif))
                .shadow(radius: 2)
        }
        .environmentObject(dependencies.exposureControlDependency)
        .onTapGesture { viewModel.lightMeterMode = .shutterSpeed }
        .disabled(viewModel.shutterSpeedMode)
    }
}
