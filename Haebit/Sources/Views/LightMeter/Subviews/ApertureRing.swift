//
//  ApertureRing.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct ApertureRing<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies

    var body: some View {
        HaebitApertureRing(selection: $viewModel.aperture, entries: viewModel.apertureValues) {
            Circle()
                .foregroundColor(.red)
                .frame(width: 5, height: 5)
        } content: { aperture in
            Text(aperture.title)
                .foregroundStyle(
                    viewModel.isCapturing
                        ? .gray
                        : viewModel.apertureMode
                            ? viewModel.aperture == aperture
                                ? .yellow
                                : .gray
                            : .white
                )
                .font(.system(size: 14, weight: .semibold, design: .monospaced))
                .shadow(radius: 2)
        }
        .disabled(viewModel.isCapturing)
        .environmentObject(dependencies.exposureControlDependency)
        .onTapGesture { viewModel.lightMeterMode = .aperture }
        .disabled(viewModel.apertureMode)
    }
}
