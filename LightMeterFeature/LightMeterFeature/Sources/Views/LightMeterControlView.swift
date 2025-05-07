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
        VStack {
            Spacer()
            VStack(spacing: 6) {
                UnlockButton(viewModel: viewModel)
                VStack(spacing: .zero) {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 5, height: 5)
                    VStack(spacing: 6) {
                        ApertureRing(viewModel: viewModel)
                        ShutterSpeedRing(viewModel: viewModel)
                        IsoRing(viewModel: viewModel)
                        ExposureBiasRing(viewModel: viewModel)
                    }
                }
                FocalRing(viewModel: viewModel)
                ZStack {
                    ShutterButton(viewModel: viewModel)
                    LoggerButton(viewModel: viewModel) { isPresentingLogger = true }
                }
                .disabled(viewModel.isCapturing)
                .padding(.vertical, 8)
                .padding(.horizontal, 20)
            }
            .background {
                BackgroundGradient()
            }
        }
        .animation(.easeIn(duration: 0.1), value: viewModel.isCapturing)
    }
}
