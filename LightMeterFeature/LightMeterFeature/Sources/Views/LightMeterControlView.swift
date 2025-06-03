//
//  LightMeterControlView.swift
//  Haebit
//
//  Created by Seunghun on 12/9/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct LightMeterControlView: View {
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies
    
    @StateObject var viewModel: HaebitLightMeterViewModel
    @Binding var isPresentingLogger: Bool
    
    var body: some View {
        VStack(spacing: 6) {
            VStack(spacing: 4) {
                Circle()
                    .foregroundColor(.red)
                    .frame(width: 5, height: 5)
                ApertureRing(viewModel: viewModel)
                ShutterSpeedRing(viewModel: viewModel)
                IsoRing(viewModel: viewModel)
                ExposureCompensationRing(viewModel: viewModel)
                FocalRing(viewModel: viewModel)
            }
            ZStack {
                ExposureCompensationButton(viewModel: viewModel)
                ShutterButton(viewModel: viewModel)
                LoggerButton(viewModel: viewModel) { isPresentingLogger = true }
            }
            .disabled(viewModel.isCapturing)
            .padding(.top, 8)
            .padding(.horizontal, 40)
        }
        .background {
            BackgroundGradient()
        }
        .animation(.easeIn(duration: 0.1), value: viewModel.isCapturing)
    }
}
