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
            HaebitApertureRing(
                selection: $viewModel.focalLength,
                entries: $viewModel.focalLengthValues,
                feedbackStyle: .constant(viewModel.focalRingFeedbackStyle.impactGeneratorFeedbackSyle),
                isMute: .constant(true)
            ) {
                Rectangle()
                    .foregroundStyle(.white)
                    .frame(width: 2, height: 6)
                    .cornerRadius(0.5)
            } content: { focalLength in
                Text(focalLength.title)
                    .foregroundStyle(.green)
                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                    .shadow(radius: 2)
            }
        }
    }
}
