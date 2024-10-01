//
//  DefaultLightMeterPreferenceProvider.swift
//  HaebitDev
//
//  Created by Seunghun on 7/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels
import LightMeterFeature

final class DefaultLightMeterPreferenceProvider: LightMeterPreferenceProvidable {
    @Published private var _apertureValues: [ApertureValue] = [
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
    
    @Published private var _shutterSpeedValues: [ShutterSpeedValue] = [
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
    
    @Published private var _isoValues: [IsoValue] = [
        .init(100),
        .init(200),
        .init(400),
    ].compactMap { $0 }
    
    @Published private var _focalLengthValues: [FocalLengthValue] = [
        .init(50),
        .init(300),
    ].compactMap { $0 }
    
    var aperturesPublisher: AnyPublisher<[ApertureValue], Never> { $_apertureValues.compactMap { $0 }.eraseToAnyPublisher() }
    var shutterSpeedsPublisher: AnyPublisher<[ShutterSpeedValue], Never> { $_shutterSpeedValues.compactMap { $0 }.eraseToAnyPublisher() }
    var isoValuesPublisher: AnyPublisher<[IsoValue], Never> { $_isoValues.compactMap { $0 }.eraseToAnyPublisher() }
    var focalLengthsPublisher: AnyPublisher<[FocalLengthValue], Never> { $_focalLengthValues.compactMap { $0 }.eraseToAnyPublisher() }
    var apertureRingFeedbackStylePublisher: AnyPublisher<LightMeterFeature.FeedbackStyle, Never> { Just(.light).eraseToAnyPublisher() }
    var shutterSpeedRingFeedbackStylePublisher: AnyPublisher<LightMeterFeature.FeedbackStyle, Never> { Just(.light).eraseToAnyPublisher() }
    var isoRingFeedbackStylePublisher: AnyPublisher<LightMeterFeature.FeedbackStyle, Never> { Just(.light).eraseToAnyPublisher() }
    var focalLengthRingFeedbackStylePublisher: AnyPublisher<LightMeterFeature.FeedbackStyle, Never> { Just(.soft).eraseToAnyPublisher() }
    var filmCanisterPublisher: AnyPublisher<HaebitCommonModels.FilmCanister, Never> { Just(.cinestill400D).eraseToAnyPublisher() }
}
