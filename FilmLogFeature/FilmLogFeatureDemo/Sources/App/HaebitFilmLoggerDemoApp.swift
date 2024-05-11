import FilmLogFeature
import HaebitLogger
import SwiftUI

@main
struct HaebitFilmLoggerDemoApp: App {
    let logger = HaebitLogger(repository: DefaultHaebitLogRepository())
    
    var body: some Scene {
        WindowGroup {
            HaebitFilmLogView(
                viewModel: HaebitFilmLogViewModel(
                    logger: logger
                )
            )
        }
    }
}
