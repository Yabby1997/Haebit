import Foundation
import LightMeterFeature

actor MockLightMeterLogger: HaebitLightMeterLoggable {
    func save(
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
    ) async throws {}
}
