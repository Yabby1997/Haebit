//
//  LightMeterPreferenceProvidable.swift
//  LightMeterFeature
//
//  Created by Seunghun on 7/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels

public protocol LightMeterPreferenceProvidable: AnyObject {
    var aperturesPublisher: AnyPublisher<[ApertureValue], Never> { get }
    var shutterSpeedsPublisher: AnyPublisher<[ShutterSpeedValue], Never> { get }
    var isoValuesPublisher: AnyPublisher<[IsoValue], Never> { get }
    var focalLengthsPublisher: AnyPublisher<[FocalLengthValue], Never> { get }
    var apertureRingFeedbackStylePublisher: AnyPublisher<FeedbackStyle, Never> { get }
    var shutterSpeedRingFeedbackStylePublisher: AnyPublisher<FeedbackStyle, Never> { get }
    var isoRingFeedbackStylePublisher: AnyPublisher<FeedbackStyle, Never> { get }
    var focalLengthRingFeedbackStylePublisher: AnyPublisher<FeedbackStyle, Never> { get }
    var filmCanisterPublisher: AnyPublisher<FilmCanister, Never> { get }
}
