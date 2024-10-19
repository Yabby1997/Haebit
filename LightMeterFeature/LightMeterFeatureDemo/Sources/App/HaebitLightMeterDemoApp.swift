import LightMeterFeature
import HaebitUI
import SwiftUI

@main
struct HaebitLightMeterDemoApp: App {
    let camera: MockLightMeterCamera
    let preferenceProvider: MockLightMeterPreferenceProvider
    @State var isPresentingConfig: Bool = false
    
    init() {
        camera = MockLightMeterCamera(screenScaleFactor: UIScreen.main.scale)
        preferenceProvider = MockLightMeterPreferenceProvider()
    }
    
    var body: some Scene {
        WindowGroup {
            HaebitLightMeterView(
                viewModel: HaebitLightMeterViewModel(
                    camera: camera,
                    logger: MockLightMeterLogger(),
                    preferenceProvider: preferenceProvider,
                    statePersistence: MockStatePersistence(),
                    reviewRequestValidator: MockReviewRequestValidator(),
                    gpsAccessValidator: MockGPSAccessValidator()
                ),
                isPresentingLogger: .constant(false),
                isPresentingConfig: $isPresentingConfig
            )
            .environmentObject(
                LightMeterControlViewDependencies(
                    shutterButtonDependency: HaebitShutterButtonDependencies(
                        feedbackProvidable: DefaultShutterButtonFeedbackProvider()
                    )
                )
            )
            .fullScreenCover(isPresented: $isPresentingConfig) {
                DemoLightMeterConfigView(
                    viewModel: DemoLightMeterConfigViewModel(
                        camera: camera,
                        preferenceProvider: preferenceProvider
                    )
                )
            }
        }
    }
}
