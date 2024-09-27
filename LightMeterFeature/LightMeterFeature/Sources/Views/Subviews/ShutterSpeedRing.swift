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
    
    var body: some View {
        if viewModel.isShutterSpeedFixed == false {
            HaebitApertureRing(
                selection: $viewModel.shutterSpeed,
                entries: $viewModel.shutterSpeeds,
                feedbackStyle: .constant(viewModel.shutterSpeedRingFeedbackStyle.impactGeneratorFeedbackSyle),
                isMute: .constant(false)
            ) { shutterSpeed in
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
            .onTapGesture { viewModel.lightMeterMode = .shutterSpeed }
            .disabled(viewModel.shutterSpeedMode)
        }
    }
}
