//
//  ShutterSpeedRing.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct ShutterSpeedRing<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies
    
    var body: some View {
        HaebitApertureRing(selection: $viewModel.shutterSpeed, entries: viewModel.shutterSpeedValues) { shutterSpeed in
            Text(shutterSpeed.title)
                .foregroundStyle(
                    viewModel.isCapturing
                    ? .gray
                    : viewModel.shutterSpeedMode
                    ? viewModel.shutterSpeed == shutterSpeed
                    ? .yellow
                    : .gray
                    : .white)
                .font(.system(size: 18, weight: .bold, design: .serif))
                .shadow(radius: 2)
        }
        .disabled(viewModel.isCapturing)
        .environmentObject(dependencies.exposureControlDependency)
        .onTapGesture { viewModel.lightMeterMode = .shutterSpeed }
        .disabled(viewModel.shutterSpeedMode)
    }
}
