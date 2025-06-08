//
//  MockConfigRepository.swift
//  ConfigFeatureDemo
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import ConfigFeature
import HaebitCommonModels

final class MockConfigRepository: HaebitConfigRepository {
    var isRotationNew = true
    var isExposureCompensationNew = true
    var isPreviewNew = true
    var rotation = true
    
    var apertureEntries: [ApertureEntry] = [
        .init(value: .init(1.4)!, isActive: true),
        .init(value: .init(2)!, isActive: false),
        .init(value: .init(2.8)!, isActive: false),
        .init(value: .init(4)!, isActive: true),
        .init(value: .init(5.6)!, isActive: false),
        .init(value: .init(8)!, isActive: false),
        .init(value: .init(11)!, isActive: true),
        .init(value: .init(16)!, isActive: false),
        .init(value: .init(22)!, isActive: false),
    ]
    
    var shutterSpeedEntries: [ShutterSpeedEntry] = [
        .init(value: .init(denominator: 8000)!, isActive: false),
        .init(value: .init(denominator: 4000)!, isActive: false),
        .init(value: .init(denominator: 2000)!, isActive: true),
        .init(value: .init(denominator: 1000)!, isActive: true),
        .init(value: .init(denominator: 500)!, isActive: true),
        .init(value: .init(denominator: 250)!, isActive: true),
        .init(value: .init(denominator: 125)!, isActive: true),
        .init(value: .init(denominator: 60)!, isActive: true),
        .init(value: .init(denominator: 30)!, isActive: true),
        .init(value: .init(denominator: 16)!, isActive: true),
        .init(value: .init(denominator: 8)!, isActive: true),
        .init(value: .init(denominator: 4)!, isActive: true),
        .init(value: .init(denominator: 2)!, isActive: true),
        .init(value: .init(denominator: 1)!, isActive: true),
    ]
    
    var isoEntries: [IsoEntry] = [
        .init(value: .init(25)!, isActive: false),
        .init(value: .init(50)!, isActive: false),
        .init(value: .init(100)!, isActive: false),
        .init(value: .init(200)!, isActive: true),
        .init(value: .init(400)!, isActive: true),
        .init(value: .init(800)!, isActive: true),
        .init(value: .init(1600)!, isActive: false),
        .init(value: .init(3200)!, isActive: false),
        .init(value: .init(6400)!, isActive: false),
    ]
    
    var focalLengthEntries: [ConfigFeature.FocalLengthEntry] = [
        .init(value: .init(11)!, isActive: true),
        .init(value: .init(22)!, isActive: false),
        .init(value: .init(26)!, isActive: false),
        .init(value: .init(28)!, isActive: true),
        .init(value: .init(35)!, isActive: false),
        .init(value: .init(50)!, isActive: true),
        .init(value: .init(75)!, isActive: true),
        .init(value: .init(80)!, isActive: false),
        .init(value: .init(100)!, isActive: true),
        .init(value: .init(135)!, isActive: true),
        .init(value: .init(150)!, isActive: true),
        .init(value: .init(200)!, isActive: true),
        .init(value: .init(300)!, isActive: false),
    ]
    
    var apertureRingFeedbackStyle: FeedbackStyle = .rigid
    var shutterSpeedDialFeedbackStyle: FeedbackStyle = .rigid
    var isoDialFeedbackStyle: FeedbackStyle = .rigid
    var exposureCompensationDialFeedbackStyle: FeedbackStyle = .rigid
    var focalLengthRingFeedbackStyle: FeedbackStyle = .rigid
    var shutterSound: Bool = true
    var perforationShape: PerforationShape = .bh
    var previewType: PreviewType = .fullScreen
    var filmCanister: FilmCanister = .fujiXtra400
}
