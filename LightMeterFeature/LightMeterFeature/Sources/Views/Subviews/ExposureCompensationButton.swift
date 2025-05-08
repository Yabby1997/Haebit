//
//  ExposureCompensationButton.swift
//  LightMeterFeature
//
//  Created by Seunghun on 5/9/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI

struct ExposureCompensationButton: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    var body: some View {
        HStack {
            Button(action: viewModel.didTapExposureCompensationButton) {
                HStack {
                    Image(asset: LightMeterFeatureAsset.exposureCompensation)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("\(viewModel.exposureCompensation > 0 ? "+" : "")\(String(format: "%.1f", (viewModel.exposureCompensation * 10).rounded() / 10))")
                }
                .foregroundStyle(.white)
                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                .contentTransition(.numericText())
                .animation(.easeInOut, value: viewModel.exposureCompensation)
            }
            Spacer()
        }
    }
}
