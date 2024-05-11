import Foundation
import LightMeterFeature

actor MockLightMeterLogger: HaebitLightMeterLoggable {
    func save(
        date: Date,
        latitude: Double?,
        longitude: Double?,
        image: String,
        focalLength: UInt16,
        iso: UInt16,
        shutterSpeed: Float,
        aperture: Float,
        memo: String
    ) {}
}
