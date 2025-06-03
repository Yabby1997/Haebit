//
//  FocalRing.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels
import HaebitUI

struct FocalRing: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    var body: some View {
        if viewModel.isFocalLengthFixed == false {
            VStack(spacing: 4) {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 2, height: 6)
                    .cornerRadius(0.5)
                HaebitApertureRing(
                    selection: $viewModel.focalLength,
                    entries: $viewModel.focalLengths,
                    feedbackStyle: .constant(viewModel.focalRingFeedbackStyle.impactGeneratorFeedbackSyle),
                    isMute: .constant(true)
                ) { focalLength in
                    FocalRingView(focalLength: focalLength, viewModel: viewModel)
                }
                .frame(height: 30)
            }
        }
    }
}

struct FocalRingView: View {
    let focalLength: FocalLengthValue
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    var body: some View {
        Text(focalLength.title)
            .foregroundStyle(.green)
            .frame(width: viewModel.orientation.isLandscape ? 30 : 60, height: viewModel.orientation.isLandscape ? 60 : 30)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .font(.system(size: 14, weight: .bold, design: .monospaced))
            .rotationEffect(viewModel.orientation.angle)
            .animation(.easeInOut, value: viewModel.orientation)
            .shadow(radius: 2)
    }
}
