//
//  MockLightMeterPreferenceProvider.swift
//  LightMeterFeatureDemo
//
//  Created by Seunghun on 7/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels
import LightMeterFeature

final class MockLightMeterPreferenceProvider: LightMeterPreferenceProvidable {
    @Published var rawApertures = "1,1.4,2,2.8,4,5.6,8,11,16,22"
    @Published var rawShutterSpeeds = "1/8000,1/4000,1/2000,1/1000,1/500,1/250,1/125,1/60,1/30,1/15,1/8,1/4,1/2,1/1,2/1,4/1,8/1,15/1,30/1,60/1"
    @Published var rawIsos = "25,50,100,200,400,800,1600,3200,6400,12800,25600,51200"
    @Published var rawFocalLengths = "28,35,40,50,70,85,100,135,170,200"
    
    @Published var apertureRingFeedbackStyle: FeedbackStyle = .light
    @Published var shutterSpeedDialFeedbackStyle: FeedbackStyle = .light
    @Published var isoDialFeedbackStyle: FeedbackStyle = .light
    @Published var exposureCompensationDialFeedbackStyle: FeedbackStyle = .light
    @Published var focalLengthRingFeedbackStyle: FeedbackStyle = .soft
    @Published var fullScreenPreview = true
    @Published var filmCanister: FilmCanister = .kodakUltramax400
    
    var apertures: [HaebitCommonModels.ApertureValue] { rawApertures.components(separatedBy: ",").compactMap { Float($0) }.compactMap { ApertureValue($0) } }
    var shutterSpeeds: [HaebitCommonModels.ShutterSpeedValue] {
        rawShutterSpeeds.components(separatedBy: ",")
            .compactMap { each -> ShutterSpeedValue? in
                let components = each.components(separatedBy: "/")
                guard components.count == 2,
                      let numerator = UInt32(components[0]),
                      let denominator = UInt32(components[1]) else { return nil }
                return ShutterSpeedValue(numerator: numerator, denominator: denominator)
            }
    }
    var isoValues: [HaebitCommonModels.IsoValue] { rawIsos.components(separatedBy: ",").compactMap { UInt32($0) }.compactMap { IsoValue($0) } }
    var focalLengths: [HaebitCommonModels.FocalLengthValue] { rawFocalLengths.components(separatedBy: ",").compactMap { UInt32($0) }.compactMap { FocalLengthValue($0) } }
    var shutterSound: Bool { true }
}
