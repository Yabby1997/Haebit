import Foundation
import HaebitCommonModels
import LightMeterFeature

class MockStatePersistence: LightMeterStatePersistenceProtocol {
    var mode: LightMeterMode = .shutterSpeed
    var aperture: ApertureValue = .init(value: 11)
    var shutterSpeed: ShutterSpeedValue = .init(denominator: 2000)!
    var iso: IsoValue = .init(iso: 400)
    var focalLength: FocalLengthValue = .init(value: 50)
}
