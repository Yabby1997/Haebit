import LightMeterFeature
import HaebitUI
import SwiftUI

@main
struct HaebitLightMeterDemoApp: App {
    var body: some Scene {
        WindowGroup {
            HaebitLightMeterView(
                viewModel: HaebitLightMeterViewModel(
                    logger: MockLightMeterLogger(),
                    statePersistence: MockStatePersistence(),
                    reviewRequestValidator: MockReviewRequestValidator(),
                    gpsAccessValidator: MockGPSAccessValidator(),
                    feedbackProvider: LightMeterHapticFeedbackProvider()
                ),
                logView: MockLogView()
            )
            .environmentObject(
                LightMeterControlViewDependencies(
                    exposureControlDependency: HaebitApertureRingDependencies(
                        feedbackProvidable: ApertureRingExposureFeedbackProvider()
                    ),
                    zoomControlDependency: HaebitApertureRingDependencies(
                        feedbackProvidable: ApertureRingZoomFeedbackProvider()
                    ),
                    shutterButtonDependency: HaebitShutterButtonDependencies(
                        feedbackProvidable: DefaultShutterButtonFeedbackProvider()
                    )
                )
            )
        }
    }
}
