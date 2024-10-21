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
                VStack {
                    HStack(spacing: .zero) {
                        Image.sparkles
                        Text(.configOnboardingViewNew)
                        Image.sparkles
                    }
                    Text(.configOnboardingViewTitle)
                }
                .font(.system(size: 12, weight: .bold, design: .serif))
            }
            .shadow(radius: 10)
            .offset(y: viewModel.offset)
        }
        .padding()
        .animation(.bouncy, value: viewModel.offset)
    }
}
