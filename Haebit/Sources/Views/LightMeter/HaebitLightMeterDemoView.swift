//
//  HaebitLightMeterDemoView.swift
//  Haebit
//
//  Created by Seunghun on 12/10/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct HaebitLightMeterDemoView<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel
    let image: String
    
    var body: some View {
        ZStack {
            LightMeterResultView(
                resultDescription: viewModel.resultDescription,
                exposureValue: viewModel.exposureValue,
                isLocked: viewModel.isLocked
            )
            LightMeterControlView(viewModel: viewModel)
            if let point = viewModel.lockPoint {
                LockIindicatorView(point: point, isHighlighted: viewModel.isLocked)
            }
        }
        .background(Image(image).resizable().scaledToFill().ignoresSafeArea())
        .onTapGesture(coordinateSpace: .local, perform: viewModel.didTap(point:))
    }
}

#Preview {
    HaebitLightMeterDemoView(
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 0.58,
            lightMeterMode: .aperture,
            iso: IsoValue(iso: 6400),
            lockPoint: CGPoint(x: 315, y: 390),
            isLocked: true
        ),
        image: "train"
    )
    .environmentObject(HaebitApertureRingDependencies(feedbackProvidable: ApertureRingFeedbackProvider()))
}

#Preview {
    HaebitLightMeterDemoView(
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 2.78,
            aperture: ApertureValue(value: 16),
            iso: IsoValue(iso: 100),
            lockPoint: CGPoint(x: 50, y: 478)
        ),
        image: "sunset"
    )
    .environmentObject(HaebitApertureRingDependencies(feedbackProvidable: ApertureRingFeedbackProvider()))
}

#Preview {
    HaebitLightMeterDemoView(
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 12.38,
            lightMeterMode: .iso,
            aperture: ApertureValue(value: 11)
        ),
        image: "beach"
    )
    .environmentObject(HaebitApertureRingDependencies(feedbackProvidable: ApertureRingFeedbackProvider()))
}

#Preview {
    HaebitLightMeterDemoView(
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 8.38,
            lightMeterMode: .shutterSpeed,
            aperture: ApertureValue(value: 4)
        ),
        image: "seoul"
    )
    .environmentObject(HaebitApertureRingDependencies(feedbackProvidable: ApertureRingFeedbackProvider()))
}
