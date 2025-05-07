//
//  ExposureBiasRIng.swift
//  LightMeterFeature
//
//  Created by Seunghun on 5/7/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels
import HaebitUI

struct ExposureBiasRing: View {
    @StateObject var viewModel: HaebitLightMeterViewModel

    var body: some View {
        if viewModel.isFocalLengthFixed == false {
            HaebitApertureRing(
                selection: $viewModel.exposureBias,
                entries: $viewModel.exposureBiases,
                feedbackStyle: .constant(viewModel.focalRingFeedbackStyle.impactGeneratorFeedbackSyle),
                isMute: .constant(true)
            ) { bias in
                Text("\(bias > 0 ? "+" : "")\(Int(bias))\(bias != 0 ? ".0" : "")")
                    .foregroundStyle(.white)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(radius: 2)
            }
            .frame(height: 30)
        }
    }
}
