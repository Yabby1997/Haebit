//
//  FocalRing.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct FocalRing: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    var body: some View {
        if viewModel.isFocalLengthFixed == false {
            VStack(spacing: .zero) {
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
                    Text(focalLength.title)
                        .foregroundStyle(.green)
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
}
