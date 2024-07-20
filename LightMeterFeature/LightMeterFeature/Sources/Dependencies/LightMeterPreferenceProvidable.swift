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
    var apertureValues: AnyPublisher<[ApertureValue], Never> { get }
    var shutterSpeedValues: AnyPublisher<[ShutterSpeedValue], Never> { get }
    var isoValues: AnyPublisher<[IsoValue], Never> { get }
    var focalLengthValues: AnyPublisher<[FocalLengthValue], Never> { get }
    var apertureRingFeedbackStyle: AnyPublisher<FeedbackStyle, Never> { get }
    var shutterSpeedRingFeedbackStyle: AnyPublisher<FeedbackStyle, Never> { get }
    var isoRingFeedbackStyle: AnyPublisher<FeedbackStyle, Never> { get }
    var focalLengthRingFeedbackStyle: AnyPublisher<FeedbackStyle, Never> { get }
}
