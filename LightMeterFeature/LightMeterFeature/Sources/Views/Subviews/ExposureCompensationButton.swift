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
                    Text("\(viewModel.exposureCompensation.formatted)")
                }
                .rotationEffect(viewModel.orientation.angle)
                .foregroundStyle(viewModel.isExposureCompensationMode ? .white : .gray)
                .font(.system(size: 16, weight: .semibold, design: .monospaced))
                .shadow(radius: 2)
                .contentTransition(.numericText())
                .animation(.easeInOut, value: viewModel.exposureCompensation)
                .animation(.easeInOut, value: viewModel.isExposureCompensationMode)
                .animation(.easeInOut, value: viewModel.orientation)
            }
            Spacer()
        }
    }
}

private extension Float {
    var formatted: String {
        let sign = self == .zero ? " " : self > .zero ? "+" : ""
        return sign + String(format: "%.1f", self)
    }
}
