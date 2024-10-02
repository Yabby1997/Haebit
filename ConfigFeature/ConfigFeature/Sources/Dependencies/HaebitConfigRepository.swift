//
//  HaebitConfigRepository.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

public protocol HaebitConfigRepository: AnyObject {
    var apertureEntries: [ApertureEntry] { get set }
    var shutterSpeedEntries: [ShutterSpeedEntry] { get set }
    var isoEntries: [IsoEntry] { get set }
    var focalLengthEntries: [FocalLengthEntry] { get set }
    var apertureRingFeedbackStyle: FeedbackStyle { get set }
    var shutterSpeedDialFeedbackStyle: FeedbackStyle { get set }
    var isoDialFeedbackStyle: FeedbackStyle { get set }
    var focalLengthRingFeedbackStyle: FeedbackStyle { get set }
    var perforationShape: PerforationShape { get set }
    var filmCanister: FilmCanister { get set }
}
