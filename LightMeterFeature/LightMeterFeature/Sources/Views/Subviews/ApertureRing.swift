//
//  ApertureRing.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels
import HaebitUI

struct ApertureRing: View {
    @StateObject var viewModel: HaebitLightMeterViewModel

    var body: some View {
        if viewModel.isApertureFixed == false {
            HaebitApertureRing(
                selection: $viewModel.aperture,
                entries: $viewModel.apertures,
                feedbackStyle: .constant(viewModel.apertureRingFeedbackStyle.impactGeneratorFeedbackSyle),
                isMute: .constant(false)
            ) { aperture in
                ApertureRingEntry(aperture: aperture, viewModel: viewModel)
            }
            .onTapGesture { viewModel.lightMeterMode = .aperture }
            .disabled(viewModel.apertureMode)
        }
    }
}

struct ApertureRingEntry: View {
    let aperture: ApertureValue
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    var body: some View {
        Text(aperture.title)
            .foregroundStyle(
                viewModel.apertureMode
                    ? viewModel.aperture == aperture
                        ? .yellow
                        : .gray
                    : .white
            )
            .animation(.easeInOut(duration: 0.2), value: viewModel.aperture == aperture)
            .animation(.easeInOut(duration: 0.2), value: viewModel.apertureMode)
            .font(.system(size: 14, weight: .semibold, design: .monospaced))
            .minimumScaleFactor(0.7)
            .lineLimit(1)
            .fixedSize(horizontal: false, vertical: true)
            .shadow(radius: 2)
    }
}
