//
//  DefaultHaebitConfigRepository.swift
//  HaebitDev
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//


@preconcurrency
import Combine
import ConfigFeature
import Foundation
import HaebitCommonModels
import LightMeterFeature

actor DefaultHaebitConfigRepository: HaebitConfigRepository, @preconcurrency LightMeterPreferenceProvidable {
    @Published private(set) var apertureEntries: [ApertureEntry] = [
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
    
    @Published private(set) var shutterSpeedEntries: [ShutterSpeedEntry] = [
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
    
    @Published private(set) var isoEntries: [IsoEntry] = [
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
    
    @Published private(set) var focalLengthEntries: [ConfigFeature.FocalLengthEntry] = [
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
    
    var apertures: [ApertureValue] { apertureEntries.filter { $0.isActive }.map { $0.value } }
    var shutterSpeeds: [ShutterSpeedValue] { shutterSpeedEntries.filter { $0.isActive }.map { $0.value } }
    var isoValues: [IsoValue] { isoEntries.filter { $0.isActive }.map { $0.value } }
    var focalLengths: [FocalLengthValue] { focalLengthEntries.filter { $0.isActive }.map { $0.value } }
    
    @Published var apertureRingFeedbackStyle: FeedbackStyle = .rigid
    @Published var shutterSpeedDialFeedbackStyle: FeedbackStyle = .rigid
    @Published var isoDialFeedbackStyle: FeedbackStyle = .rigid
    @Published var focalLengthRingFeedbackStyle: FeedbackStyle = .rigid
    @Published var perforationShape: PerforationShape = .bh
    @Published var filmCanister: FilmCanister = .fujiXtra400
    
    func saveAperture(entries: [ConfigFeature.ApertureEntry]) {
        apertureEntries = entries
    }
    
    func saveShutterSpeed(entries: [ConfigFeature.ShutterSpeedEntry]) {
        shutterSpeedEntries = entries
    }
    
    func saveIso(entries: [ConfigFeature.IsoEntry]) {
        isoEntries = entries
    }
    
    func saveFocalLength(entries: [ConfigFeature.FocalLengthEntry]) {
        focalLengthEntries = entries
    }
    
    func saveApertureRing(feedbackStyle: FeedbackStyle) {
        print(#function)
    }
    
    func saveShutterSpeedDial(feedbackStyle: FeedbackStyle) {
        print(#function)
    }
    
    func saveIsoDial(feedbackStyle: FeedbackStyle) {
        print(#function)
    }
    
    func savePerforationShape(_ perforationShape: HaebitCommonModels.PerforationShape) {
        print(#function)
    }
    
    func saveFilmCanister(_ filmCanister: HaebitCommonModels.FilmCanister) {
        print(#function)
    }
}
