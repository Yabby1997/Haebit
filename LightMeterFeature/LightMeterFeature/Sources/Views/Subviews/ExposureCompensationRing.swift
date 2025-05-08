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
        HaebitApertureRing(
            selection: $viewModel.exposureCompensation,
            entries: $viewModel.exposureCompensationValues,
            cellWidth: 24,
            feedbackStyle: .constant(viewModel.focalRingFeedbackStyle.impactGeneratorFeedbackSyle),
            isMute: .constant(true)
        ) { bias in
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(1)
                .frame(width: 3, height: bias.remainder(dividingBy: 1.0) == .zero ? 12: 8)
                .offset(y: bias.remainder(dividingBy: 1.0) == .zero ? .zero : 2)
        }
        .opacity(viewModel.isExposureCompensationRingVisible ? 1.0 : .zero)
        .frame(height: viewModel.isExposureCompensationRingVisible ? 24 : .zero)
    }
}
