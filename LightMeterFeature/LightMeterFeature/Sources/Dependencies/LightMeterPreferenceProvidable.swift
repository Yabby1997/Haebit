//
//  LightMeterPreferenceProvidable.swift
//  LightMeterFeature
//
//  Created by Seunghun on 7/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

public protocol LightMeterPreferenceProvidable: AnyObject {
    var apertures: [ApertureValue] { get }
    var shutterSpeeds: [ShutterSpeedValue] { get }
    var isoValues: [IsoValue] { get }
    var focalLengths: [FocalLengthValue] { get }
    var apertureRingFeedbackStyle: FeedbackStyle { get }
    var shutterSpeedDialFeedbackStyle: FeedbackStyle { get }
    var isoDialFeedbackStyle: FeedbackStyle { get }
    var exposureCompensationDialFeedbackStyle: FeedbackStyle { get }
    var focalLengthRingFeedbackStyle: FeedbackStyle { get }
    var shutterSound: Bool { get }
    var filmCanister: FilmCanister { get }
}
