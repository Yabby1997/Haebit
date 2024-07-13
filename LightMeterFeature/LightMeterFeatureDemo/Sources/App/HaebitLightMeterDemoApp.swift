import LightMeterFeature
import HaebitUI
import SwiftUI

@main
struct HaebitLightMeterDemoApp: App {
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    init() {
        _viewModel = StateObject(
            wrappedValue: HaebitLightMeterViewModel(
                camera: MockLightMeterCamera(),
                logger: MockLightMeterLogger(),
                preferenceProvider: MockLightMeterPreferenceProvider(),
                statePersistence: MockStatePersistence(),
                reviewRequestValidator: MockReviewRequestValidator(),
                gpsAccessValidator: MockGPSAccessValidator()
            )
        )
    }
    
    var body: some Scene {
        WindowGroup {
            HaebitLightMeterView(
                viewModel: viewModel,
                logView: EmptyView()
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
