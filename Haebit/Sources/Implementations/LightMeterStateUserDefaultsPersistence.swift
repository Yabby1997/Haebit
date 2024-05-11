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
    @UserDefault(key: "LightMeterStateUserDefaultsPersistence.mode", defaultValue: .shutterSpeed)
    var mode: LightMeterMode
    
    @UserDefault(key: "LightMeterStateUserDefaultsPersistence.aperture", defaultValue: ApertureValue(value: 1.4))
    var aperture: ApertureValue
    
    @UserDefault(key: "LightMeterStateUserDefaultsPersistence.shutterSpeed", defaultValue: ShutterSpeedValue(denominator: 60)!)
    var shutterSpeed: ShutterSpeedValue
    
    @UserDefault(key: "LightMeterStateUserDefaultsPersistence.iso", defaultValue: IsoValue(iso: 200))
    var iso: IsoValue
    
    @UserDefault(key: "LightMeterStateUserDefaultsPersistence.focalLength", defaultValue: FocalLengthValue(value: 50))
    var focalLength: FocalLengthValue
}
