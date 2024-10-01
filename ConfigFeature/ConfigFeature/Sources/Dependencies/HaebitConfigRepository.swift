//
//  HaebitConfigRepository.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels

public protocol HaebitConfigRepository: Actor {
    var apertureEntries: [ApertureEntry] { get }
    var shutterSpeedEntries: [ShutterSpeedEntry] { get }
    var isoEntries: [IsoEntry] { get }
    var focalLengthEntries: [FocalLengthEntry] { get }
    var apertureRingFeedbackStyle: FeedbackStyle { get }
    var shutterSpeedDialFeedbackStyle: FeedbackStyle { get }
    var isoDialFeedbackStyle: FeedbackStyle { get }
    var focalLengthRingFeedbackStyle: FeedbackStyle { get }
    var perforationShape: PerforationShape { get }
    var filmCanister: FilmCanister { get }
    
    func saveAperture(entries: [ApertureEntry])
    func saveShutterSpeed(entries: [ShutterSpeedEntry])
    func saveIso(entries: [IsoEntry])
    func saveFocalLength(entries: [FocalLengthEntry])
    func saveApertureRing(feedbackStyle: FeedbackStyle)
    func saveShutterSpeedDial(feedbackStyle: FeedbackStyle)
    func saveIsoDial(feedbackStyle: FeedbackStyle)
    func savePerforationShape(_ perforationShape: PerforationShape)
    func saveFilmCanister(_ filmCanister: FilmCanister)
}
