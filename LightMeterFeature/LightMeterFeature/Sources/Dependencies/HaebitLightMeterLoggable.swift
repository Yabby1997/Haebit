import Foundation

public protocol HaebitLightMeterLoggable: Actor {
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
    ) async throws
}
