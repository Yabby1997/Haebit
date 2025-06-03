//
//  ExposureCompensationRing.swift
//  LightMeterFeature
//
//  Created by Seunghun on 5/7/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels
import HaebitUI

struct ExposureCompensationRing: View {
    @StateObject var viewModel: HaebitLightMeterViewModel

    var body: some View {
        if viewModel.isExposureCompensationModeToggled {
            HaebitApertureRing(
                selection: $viewModel.exposureCompensation,
                entries: $viewModel.exposureCompensationValues,
                cellWidth: 24,
                feedbackStyle: .constant(viewModel.exposureCompensationDialFeedbackStyle.impactGeneratorFeedbackSyle),
                isMute: .constant(false)
            ) { value in
                ExposureCompensationEntry(value: value, viewModel: viewModel)
            }
            .opacity(viewModel.isExposureCompensationMode ? 1.0 : .zero)
            .frame(height: viewModel.isExposureCompensationMode ? 24 : .zero)
            .animation(.easeInOut, value: viewModel.isExposureCompensationMode)
        }
    }
}

struct ExposureCompensationEntry: View {
    let value: Float
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    var body: some View {
        Rectangle()
            .foregroundStyle(viewModel.exposureCompensation == value ? .yellow : .white)
            .animation(.easeInOut(duration: 0.1), value: viewModel.exposureCompensation)
            .cornerRadius(1)
            .frame(width: viewModel.exposureCompensation == value ? 3 : 2, height: value.remainder(dividingBy: 1.0) == .zero ? 14: 10)
            .offset(y: value.remainder(dividingBy: 1.0) == .zero ? .zero : 2)
            .shadow(radius: 2)
    }
}
