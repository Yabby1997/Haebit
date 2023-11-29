import SwiftUI

@main
struct HaebitApp: App {
    var body: some Scene {
        WindowGroup {
            HaebitLightMeterView(viewModel: HaebitLightMeterViewModel())
        }
    }
}
