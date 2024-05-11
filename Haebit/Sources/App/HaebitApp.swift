//
//  HaebitApp.swift
//  Haebit
//
//  Created by Seunghun on 11/15/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import FilmLogFeature
import HaebitLogger
import HaebitUI
import LightMeterFeature
import SwiftUI

@main
struct HaebitApp: App {
    let logger = HaebitLogger(repository: DefaultHaebitLogRepository())
    
    var body: some Scene {
        WindowGroup {
            HaebitLightMeterView(
                viewModel: HaebitLightMeterViewModel(
                    logger: logger,
                    statePersistence: LightMeterStateUserDefaultsPersistence(),
                    reviewRequestValidator: DefaultReviewRequestValidator(), 
                    gpsAccessValidator: DefaultGPSAccessValidator(),
                    feedbackProvider: LightMeterHapticFeedbackProvider()
                ),
                logView: HaebitFilmLogView(
                    viewModel: HaebitFilmLogViewModel(
                        logger: logger
                    )
                )
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

extension HaebitLogger: HaebitLightMeterLoggable {
    public func save(
        date: Date,
        latitude: Double?,
        longitude: Double?,
        image: String,
        focalLength: UInt16,
        iso: UInt16,
        shutterSpeed: Float,
        aperture: Float,
        memo: String
    ) async throws {
        var coordinate: HaebitCoordinate?
        if let latitude, let longitude {
            coordinate = HaebitCoordinate(latitude: latitude, longitude: longitude)
        }
        
        try await save(
            log: HaebitLog(
                date: date,
                coordinate: coordinate,
                image: image,
                focalLength: focalLength,
                iso: iso,
                shutterSpeed: shutterSpeed,
                aperture: aperture,
                memo: memo
            )
        )
    }
}
