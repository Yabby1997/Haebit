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
    @Published var apertures = "1,1.4,2,2.8,4,5.6,8,11,16,22"
    @Published var shutterSpeeds = "1/8000,1/4000,1/2000,1/1000,1/500,1/250,1/125,1/60,1/30,1/15,1/8,1/4,1/2,1/1,2/1,4/1,8/1,15/1,30/1,60/1"
    @Published var isos = "25,50,100,200,400,800,1600,3200,6400,12800,25600,51200"
    @Published var focalLengths = "28,35,40,50,70,85,100,135,170,200"
    @Published var apertureFeedbackStyle: FeedbackStyle = .light
    @Published var shutterSpeedFeedbackStyle: FeedbackStyle = .light
    @Published var isoFeedbackStyle: FeedbackStyle = .light
    @Published var focalLengthFeedbackStyle: FeedbackStyle = .soft

    var apertureValues: AnyPublisher<[ApertureValue], Never> {
        $apertures
            .map { $0.components(separatedBy: ",").compactMap { Float($0) }.compactMap { ApertureValue($0) } }
            .eraseToAnyPublisher()
    }
    
    var shutterSpeedValues: AnyPublisher<[ShutterSpeedValue], Never> {
        $shutterSpeeds
            .map {
                $0.components(separatedBy: ",")
                    .compactMap { each -> ShutterSpeedValue? in
                        let components = each.components(separatedBy: "/")
                        guard components.count == 2,
                              let numerator = UInt32(components[0]),
                              let denominator = UInt32(components[1]) else { return nil }
                        return ShutterSpeedValue(numerator: numerator, denominator: denominator)
                    }
            }
            .eraseToAnyPublisher()
    }
    
    var isoValues: AnyPublisher<[IsoValue], Never> {
        $isos
            .map { $0.components(separatedBy: ",").compactMap { UInt32($0) }.compactMap { IsoValue($0) } }
            .eraseToAnyPublisher()
    }
    
    var focalLengthValues: AnyPublisher<[FocalLengthValue], Never> {
        $focalLengths
            .map { $0.components(separatedBy: ",").compactMap { UInt32($0) }.compactMap { FocalLengthValue($0) } }
            .eraseToAnyPublisher()
    }
    
    var apertureRingFeedbackStyle: AnyPublisher<LightMeterFeature.FeedbackStyle, Never> {
        $apertureFeedbackStyle.map { $0.lightMeterFeatureFeedbackStyle }.eraseToAnyPublisher()
    }
    
    var shutterSpeedRingFeedbackStyle: AnyPublisher<LightMeterFeature.FeedbackStyle, Never> {
        $shutterSpeedFeedbackStyle.map { $0.lightMeterFeatureFeedbackStyle }.eraseToAnyPublisher()
    }
    
    var isoRingFeedbackStyle: AnyPublisher<LightMeterFeature.FeedbackStyle, Never> {
        $isoFeedbackStyle.map { $0.lightMeterFeatureFeedbackStyle }.eraseToAnyPublisher()
    }
    
    var focalLengthRingFeedbackStyle: AnyPublisher<LightMeterFeature.FeedbackStyle, Never> {
        $focalLengthFeedbackStyle.map { $0.lightMeterFeatureFeedbackStyle }.eraseToAnyPublisher()
    }
}

extension FeedbackStyle {
    var lightMeterFeatureFeedbackStyle: LightMeterFeature.FeedbackStyle {
        switch self {
        case .heavy: return .heavy
        case .medium: return .medium
        case .light: return .light
        case .rigid: return .rigid
        case .soft: return .soft
        }
    }
}
