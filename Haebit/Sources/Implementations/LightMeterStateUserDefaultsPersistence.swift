//
//  LightMeterStateUserDefaultsPersistence.swift
//  Haebit
//
//  Created by Seunghun on 12/27/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels
import LightMeterFeature

final class LightMeterStateUserDefaultsPersistence: LightMeterStatePersistenceProtocol {
    enum UserDefaultKey: String, CaseIterable {
        case mode = "LightMeterStateUserDefaultsPersistence.mode"
        case aperture = "LightMeterStateUserDefaultsPersistence.aperture"
        case shutterSpeed = "LightMeterStateUserDefaultsPersistence.shutterSpeed"
        case iso = "LightMeterStateUserDefaultsPersistence.iso"
        case focalLength = "LightMeterStateUserDefaultsPersistence.focalLength"
        case exposureCompensation = "LightMeterStateUserDefaultsPersistence.exposureCompensation"
        case shouldShowConfigOnboarding = "LightMeterStateUserDefaultsPersistence.shouldShowConfigOnboarding"
    }
    
    @UserDefault(key: UserDefaultKey.mode.rawValue, defaultValue: .shutterSpeed)
    var mode: LightMeterMode
    
    @UserDefault(key: UserDefaultKey.aperture.rawValue, defaultValue: ApertureValue(1.4)!)
    var aperture: ApertureValue
    
    @UserDefault(key: UserDefaultKey.shutterSpeed.rawValue, defaultValue: ShutterSpeedValue(denominator: 60)!)
    var shutterSpeed: ShutterSpeedValue
    
    @UserDefault(key: UserDefaultKey.iso.rawValue, defaultValue: IsoValue(200)!)
    var iso: IsoValue
    
    @UserDefault(key: UserDefaultKey.focalLength.rawValue, defaultValue: FocalLengthValue(50)!)
    var focalLength: FocalLengthValue
    
    @UserDefault(key: UserDefaultKey.exposureCompensation.rawValue, defaultValue: .zero)
    var exposureCompensation: Float
    
    @UserDefault(key: UserDefaultKey.shouldShowConfigOnboarding.rawValue, defaultValue: true)
    var shouldShowConfigOnboarding: Bool

    func reset() {
        UserDefaultKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
}
