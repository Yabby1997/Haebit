//
//  HaebitApp.swift
//  Haebit
//
//  Created by Seunghun on 11/15/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import ConfigFeature
import FilmLogFeature
import HaebitLogger
import HaebitUI
import LightMeterFeature
import SwiftUI

@main
struct HaebitApp: App {
    let configRepository = DefaultHaebitConfigRepository()
    let logger = HaebitLogger(repository: DefaultHaebitLogRepository())
    @State var isPresentingLogger = false
    @State var isPresentingConfig = false
    
    var body: some Scene {
        WindowGroup {
            HaebitLightMeterView(
                viewModel: HaebitLightMeterViewModel(
                    camera: LightMeterObscuraCamera(),
                    logger: logger,
                    preferenceProvider: configRepository,
                    statePersistence: LightMeterStateUserDefaultsPersistence(),
                    fallbackFocalLength: UIDevice.focalLength,
                    reviewRequestValidator: DefaultReviewRequestValidator(),
                    gpsAccessValidator: DefaultGPSAccessValidator()
                ),
                isPresentingLogger: $isPresentingLogger,
                isPresentingConfig: $isPresentingConfig
            )
            .environmentObject(
                LightMeterControlViewDependencies(
                    shutterButtonDependency: HaebitShutterButtonDependencies(
                        feedbackProvidable: DefaultShutterButtonFeedbackProvider()
                    )
                )
            )
            .fullScreenCover(isPresented: $isPresentingLogger) {
                HaebitFilmLogView(logger: logger, preferenceProvider: configRepository)
            }
            .fullScreenCover(isPresented: $isPresentingConfig) {
                HaebitConfigView(
                    configRepository: configRepository,
                    appStoreOpener: HaebitAppStoreOpener(locale: Locale.current.identifier),
                    appVersionProvider: HaebitAppVersionProvider(),
                    isPresented: $isPresentingConfig
                )
            }
        }
    }
}

extension HaebitLogger: HaebitLightMeterLoggable {
    public func save(
        date: Date,
        latitude: Double?,
        longitude: Double?,
        image: String,
        focalLength: UInt32,
        iso: UInt32,
        shutterSpeedNumerator: UInt32,
        shutterSpeedDenominator: UInt32, 
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
                shutterSpeed: .init(numerator: shutterSpeedNumerator, denominator: shutterSpeedDenominator),
                aperture: aperture,
                memo: memo
            )
        )
    }
}
