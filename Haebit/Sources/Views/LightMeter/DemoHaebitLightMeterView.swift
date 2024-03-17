//
//  DemoHaebitLightMeterView.swift
//  Haebit
//
//  Created by Seunghun on 12/28/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct DemoHaebitLightMeterView<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    let imageName: String
    @StateObject var viewModel: ViewModel
    
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
        .background {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

#Preview("default") {
    DemoHaebitLightMeterView(
        imageName: "seoul",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 8.38,
            lightMeterMode: .shutterSpeed,
            aperture: .init(value: 4),
            shutterSpeed: .init(denominator: 125),
            iso: .init(iso: 400),
            focalLength: .init(value: 50),
            lockPoint: nil,
            isLocked: false
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}

#Preview("mode:aperture") {
    DemoHaebitLightMeterView(
        imageName: "beach",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 12.38,
            lightMeterMode: .aperture,
            aperture: .init(value: 11),
            shutterSpeed: .init(denominator: 125),
            iso: .init(iso: 100),
            focalLength: .init(value: 50),
            lockPoint: nil,
            isLocked: false
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}

#Preview("mode:shutterSpeed") {
    DemoHaebitLightMeterView(
        imageName: "beach",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 12.38,
            lightMeterMode: .shutterSpeed,
            aperture: .init(value: 11),
            shutterSpeed: .init(denominator: 125),
            iso: .init(iso: 100),
            focalLength: .init(value: 50),
            lockPoint: nil,
            isLocked: false
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}

#Preview("mode:iso") {
    DemoHaebitLightMeterView(
        imageName: "beach",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 12.38,
            lightMeterMode: .iso,
            aperture: .init(value: 11),
            shutterSpeed: .init(denominator: 125),
            iso: .init(iso: 100),
            focalLength: .init(value: 50),
            lockPoint: nil,
            isLocked: false
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}

#Preview("focal:50") {
    DemoHaebitLightMeterView(
        imageName: "bird50",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 11.72,
            lightMeterMode: .shutterSpeed,
            aperture: .init(value: 8),
            shutterSpeed: .init(denominator: 125),
            iso: .init(iso: 800),
            focalLength: .init(value: 50),
            lockPoint: nil,
            isLocked: false
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}

#Preview("focal:100") {
    DemoHaebitLightMeterView(
        imageName: "bird100",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 11.98,
            lightMeterMode: .shutterSpeed,
            aperture: .init(value: 8),
            shutterSpeed: .init(denominator: 125),
            iso: .init(iso: 800),
            focalLength: .init(value: 100),
            lockPoint: nil,
            isLocked: false
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}

#Preview("focal:200") {
    DemoHaebitLightMeterView(
        imageName: "bird200",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 12.33,
            lightMeterMode: .shutterSpeed,
            aperture: .init(value: 8),
            shutterSpeed: .init(denominator: 125),
            iso: .init(iso: 800),
            focalLength: .init(value: 200),
            lockPoint: nil,
            isLocked: false
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}

#Preview("tap:unlocked") {
    DemoHaebitLightMeterView(
        imageName: "trainUnlocked",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 2.78,
            lightMeterMode: .shutterSpeed,
            aperture: .init(value: 1.4),
            shutterSpeed: .init(denominator: 125),
            iso: .init(iso: 100),
            focalLength: .init(value: 70),
            lockPoint: CGPoint(x: 150, y: 230),
            isLocked: false
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}

#Preview("tap:locked") {
    DemoHaebitLightMeterView(
        imageName: "trainLocked",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 0.98,
            lightMeterMode: .shutterSpeed,
            aperture: .init(value: 1.4),
            shutterSpeed: .init(denominator: 125),
            iso: .init(iso: 100),
            focalLength: .init(value: 70),
            lockPoint: CGPoint(x: 150, y: 230),
            isLocked: true
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}


#Preview("logging") {
    DemoHaebitLightMeterView(
        imageName: "goldengate",
        viewModel: DemoHaebitLightMeterViewModel(
            exposureValue: 12.96,
            lightMeterMode: .shutterSpeed,
            aperture: .init(value: 8),
            shutterSpeed: .init(denominator: 500),
            iso: .init(iso: 400),
            focalLength: .init(value: 70),
            lockPoint: nil,
            isLocked: false
        )
    )
    .environmentObject(
        LightMeterControlViewDependencies(
            exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
            zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
            shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
        )
    )
}
