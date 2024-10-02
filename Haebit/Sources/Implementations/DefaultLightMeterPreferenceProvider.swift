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
    var apertures: [ApertureValue] {
        [
            .init(1),
            .init(1.2),
            .init(1.4),
            .init(1.7),
            .init(2),
            .init(2.8),
            .init(4.2),
            .init(5.6),
            .init(8),
            .init(11),
            .init(16),
            .init(22),
        ].compactMap { $0 }
    }
    
    var shutterSpeeds: [ShutterSpeedValue] {
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
    
    var isoValues: [IsoValue] {
        [
            .init(100),
            .init(200),
            .init(400),
        ].compactMap { $0 }
    }
    
    var focalLengths: [FocalLengthValue] {
        [
            .init(50),
            .init(300),
        ].compactMap { $0 }
    }
    
    var apertureRingFeedbackStyle: FeedbackStyle { .light }
    var shutterSpeedDialFeedbackStyle: FeedbackStyle { .light }
    var isoDialFeedbackStyle: FeedbackStyle { .light }
    var focalLengthRingFeedbackStyle: FeedbackStyle { .soft }
    var filmCanister: FilmCanister { .cinestill400D }
}
