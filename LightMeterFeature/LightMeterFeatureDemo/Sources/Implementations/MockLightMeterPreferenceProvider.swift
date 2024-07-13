//
//  MockLightMeterPreferenceProvider.swift
//  LightMeterFeatureDemo
//
//  Created by Seunghun on 7/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels
import LightMeterFeature

final class MockLightMeterPreferenceProvider: LightMeterPreferenceProvidable {
    var apertureValues: [ApertureValue] {
        [
            .init(1.7),
            .init(4.6),
            .init(8),
            .init(11),
        ].compactMap { $0 }
    }
    
    var shutterSpeedValues: [ShutterSpeedValue] {
        [
            .init(denominator: 500),
            .init(denominator: 250),
        ].compactMap { $0 }
    }
    
    var isoValues: [IsoValue] {
        [
            .init(100),
            .init(200),
            .init(400),
        ].compactMap { $0 }
    }
    
    func focalLengthValues(under maxZoomFactor: CGFloat) -> [FocalLengthValue] {
        [
            .init(22)
        ].compactMap { $0 }
    }
}
