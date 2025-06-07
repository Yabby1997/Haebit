import Foundation
import HaebitCommonModels
import LightMeterFeature

class MockStatePersistence: LightMeterStatePersistenceProtocol {
    var exposureCompensation: Float = .zero
    var mode: LightMeterMode = .shutterSpeed
    var aperture: ApertureValue = .init(11)!
    var shutterSpeed: ShutterSpeedValue = .init(denominator: 2000)!
    var iso: IsoValue = .init(400)!
    var focalLength: FocalLengthValue = .init(50)!
    var shouldShowConfigOnboarding: Bool = true
    var shouldShowConfigOnboardingForLandscape: Bool = true
}
