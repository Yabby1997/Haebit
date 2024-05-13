import LightMeterFeature
import HaebitUI
import SwiftUI

@main
struct HaebitLightMeterDemoApp: App {
    @State var isPresentingDemoSettingSheet = false
    @StateObject var viewModel = DemoLightMeterViewModel()
    
    var body: some Scene {
        WindowGroup {
            HaebitLightMeterView(
                viewModel: viewModel,
                logView: EmptyView()
            )
            .onTapGesture(count: 2) {
                isPresentingDemoSettingSheet = true
            }
            .sheet(isPresented: $isPresentingDemoSettingSheet) {
                DemoLightMeterConfigView(viewModel: viewModel)
            }
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
