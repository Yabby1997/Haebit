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
                feedbackStyle: .constant(viewModel.shutterSpeedDialFeedbackStyle.impactGeneratorFeedbackSyle),
                isMute: .constant(false)
            ) { shutterSpeed in
                ShutterSpeedRingEntry(shutterSpeed: shutterSpeed, viewModel: viewModel)
            }
            .frame(height: 30)
            .onTapGesture { viewModel.lightMeterMode = .shutterSpeed }
            .disabled(viewModel.shutterSpeedMode)
        }
    }
}

struct ShutterSpeedRingEntry: View {
    let shutterSpeed: ShutterSpeedValue
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    var body: some View {
        Text(shutterSpeed.title)
            .foregroundStyle(
                viewModel.shutterSpeedMode
                    ? viewModel.shutterSpeed == shutterSpeed
                        ? .yellow
                        : .gray
                    : .white
            )
            .frame(width: viewModel.orientation.isLandscape ? 30 : 60, height: viewModel.orientation.isLandscape ? 60 : 30)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .font(.system(size: 18, weight: .bold, design: .serif))
            .rotationEffect(viewModel.orientation.angle)
            .animation(.easeInOut, value: viewModel.orientation)
            .animation(.easeInOut(duration: 0.2), value: viewModel.shutterSpeed == shutterSpeed)
            .animation(.easeInOut(duration: 0.2), value: viewModel.shutterSpeedMode)
            .shadow(radius: 2)
    }
}
