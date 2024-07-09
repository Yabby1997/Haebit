//
//  DefaultLightMeterPreferenceProvider.swift
//  HaebitDev
//
//  Created by Seunghun on 7/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels
import LightMeterFeature

final class DefaultLightMeterPreferenceProvider: LightMeterPreferenceProvidable {
    var apertureValues: [HaebitCommonModels.ApertureValue] {
        [
            .init(4.2),
            .init(5.6),
            .init(8),
            .init(11),
        ].compactMap { $0 }
    }
    
    var shutterSpeedValues: [HaebitCommonModels.ShutterSpeedValue] {
        [
            .init(denominator: 500),
            .init(denominator: 250),
            .init(denominator: 125),
            .init(denominator: 60),
            .init(denominator: 30),
            .init(denominator: 16),
            .init(denominator: 8),
            .init(denominator: 4),
            .init(denominator: 2),
            .init(numerator: 1)
        ].compactMap { $0 }
    }
    
    var isoValues: [HaebitCommonModels.IsoValue] {
        [
            .init(100),
            .init(200),
            .init(400),
        ].compactMap { $0 }
    }
    
    func focalLengthValues(under maxZoomFactor: CGFloat) -> [HaebitCommonModels.FocalLengthValue] {
        [
            .init(50),
            .init(70),
            .init(135),
        ].compactMap { $0 }
    }
}
