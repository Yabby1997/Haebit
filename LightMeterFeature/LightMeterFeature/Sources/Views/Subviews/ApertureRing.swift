//
//  ApertureRing.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct ApertureRing: View {
    @StateObject var viewModel: HaebitLightMeterViewModel

    var body: some View {
        if viewModel.isApertureFixed == false {
            HaebitApertureRing(
                selection: $viewModel.aperture,
                entries: $viewModel.apertureValues,
                feedbackStyle: .constant(viewModel.apertureRingFeedbackStyle.impactGeneratorFeedbackSyle),
                isMute: .constant(false)
            ) { aperture in
                Text(aperture.title)
                    .foregroundStyle(
                        viewModel.apertureMode
                            ? viewModel.aperture == aperture
                                ? .yellow
                                : .gray
                            : .white
                    )
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .shadow(radius: 2)
            }
            .onTapGesture { viewModel.lightMeterMode = .aperture }
            .disabled(viewModel.apertureMode)
        }
    }
}
