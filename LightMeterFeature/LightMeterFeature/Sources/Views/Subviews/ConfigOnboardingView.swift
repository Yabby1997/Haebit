//
//  ConfigOnboardingView.swift
//  LightMeterFeature
//
//  Created by Seunghun on 10/21/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct ConfigOnboardingView: View {
    @StateObject var viewModel: ConfigOnboardingViewModel = ConfigOnboardingViewModel()
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image.handPointUpLeftFill
                    .resizable()
                    .frame(width: 35, height: 35)
                    .rotationEffect(.degrees(viewModel.isLowered ? -30 : .zero))
                VStack {
                    HStack(spacing: .zero) {
                        Image.sparkles
                        Text(.configOnboardingViewNew)
                        Image.sparkles
                    }
                    Text(.configOnboardingViewTitle)
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(.white)
            }
            .shadow(radius: 10)
            .offset(y: viewModel.isLowered ? 50 : -30)
        }
        .padding()
        .animation(
            .snappy(duration: 0.4, extraBounce: 0.2),
            value: viewModel.isLowered
        )
    }
}
