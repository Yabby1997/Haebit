//
//  LightMeterControlView.swift
//  Haebit
//
//  Created by Seunghun on 12/9/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct LightMeterControlView<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 6) {
                UnlockButton(viewModel: viewModel)
                ApertureRing(viewModel: viewModel)
                ShutterSpeedRing(viewModel: viewModel)
                IsoRing(viewModel: viewModel)
                FocalRing(viewModel: viewModel)
                ZStack {
                    LoggerButton(viewModel: viewModel)
                    ShutterButton(viewModel: viewModel)
                }
                .padding(.vertical, 8)
            }
            .background {
                BackgroundGradient()
            }
        }
        .animation(.easeIn(duration: 0.1), value: viewModel.isCapturing)
    }
}

//#Preview {
//    LightMeterControlView(viewModel: DemoHaebitLightMeterViewModel())
//        .environmentObject(
//            LightMeterControlViewDependencies(
//                exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
//                zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
//                shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
//            )
//        )
//}
