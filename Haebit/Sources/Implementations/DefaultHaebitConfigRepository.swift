//
//  DefaultHaebitConfigRepository.swift
//  HaebitDev
//
//  Created by Seunghun on 10/1/24.
//  Copyright © 2024 seunghun. All rights reserved.
//


import ConfigFeature
import FilmLogFeature
import Foundation
import HaebitCommonModels
import LightMeterFeature

final class DefaultHaebitConfigRepository: HaebitConfigRepository {
    fileprivate enum UserDefaultKey: String, CaseIterable {
        case apertureEntries = "DefaultHeabitConfigRepository.apertureEntries"
        case shutterSpeedEntries = "DefaultHeabitConfigRepository.shutterSpeedEntries"
        case isoEntries = "DefaultHeabitConfigRepository.isoEntries"
        case focalLengthEntries = "DefaultHeabitConfigRepository.focalLengthEntries"
        case shutterSound = "DefaultHaebitConfigRepository.shutterSound"
        case apertureRingFeedbackStyle = "DefaultHeabitConfigRepository.apertureRingFeedbackStyle"
        case shutterSpeedDialFeedbackStyle = "DefaultHeabitConfigRepository.shutterSpeedDialFeedbackStyle"
        case isoDialFeedbackStyle = "DefaultHeabitConfigRepository.isoDialFeedbackStyle"
        case focalLengthRingFeedbackStyle = "DefaultHeabitConfigRepository.focalLengthRingFeedbackStyle"
        case perforationShape = "DefaultHeabitConfigRepository.perforationShape"
        case filmCanister = "DefaultHeabitConfigRepository.filmCanister"
    }
    
    @UserDefault(
        key: UserDefaultKey.apertureEntries.rawValue,
        defaultValue: [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
            .compactMap { ApertureValue($0) }
            .map { ApertureEntry(value: $0, isActive: true) }
    )
    var apertureEntries: [ApertureEntry]
    
    @UserDefault(
        key: UserDefaultKey.shutterSpeedEntries.rawValue,
        defaultValue: [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2]
            .compactMap { ShutterSpeedValue(denominator: $0) }
            .map { ShutterSpeedEntry(value: $0, isActive: true) }
        + [1, 2, 4, 8, 16, 30, 60]
            .compactMap { ShutterSpeedValue(numerator: $0) }
            .map { ShutterSpeedEntry(value: $0, isActive: true) }
    )
    var shutterSpeedEntries: [ShutterSpeedEntry]
    
    @UserDefault(
        key: UserDefaultKey.isoEntries.rawValue,
        defaultValue: [25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200]
            .compactMap { IsoValue($0) }
            .map { IsoEntry(value: $0, isActive: true) }
    )
    var isoEntries: [IsoEntry]
    
    @UserDefault(
        key: UserDefaultKey.focalLengthEntries.rawValue,
        defaultValue: [28, 35, 40, 50, 70, 85, 100, 135, 170, 200]
            .compactMap { FocalLengthValue($0) }
            .map { FocalLengthEntry(value: $0, isActive: true) }
    )
    var focalLengthEntries: [ConfigFeature.FocalLengthEntry]
    @UserDefault(key: UserDefaultKey.apertureRingFeedbackStyle.rawValue, defaultValue: .rigid)
    var apertureRingFeedbackStyle: FeedbackStyle
    @UserDefault(key: UserDefaultKey.shutterSpeedDialFeedbackStyle.rawValue, defaultValue: .rigid)
    var shutterSpeedDialFeedbackStyle: FeedbackStyle
    @UserDefault(key: UserDefaultKey.isoDialFeedbackStyle.rawValue, defaultValue: .rigid)
    var isoDialFeedbackStyle: FeedbackStyle
    @UserDefault(key: UserDefaultKey.focalLengthRingFeedbackStyle.rawValue, defaultValue: .rigid)
    var focalLengthRingFeedbackStyle: FeedbackStyle
    @UserDefault(key: UserDefaultKey.shutterSound.rawValue, defaultValue: true)
    var shutterSound: Bool
    @UserDefault(key: UserDefaultKey.perforationShape.rawValue, defaultValue: .ks)
    var perforationShape: PerforationShape
    @UserDefault(key: UserDefaultKey.filmCanister.rawValue, defaultValue: .fujiXtra400)
    var filmCanister: FilmCanister
    
    func reset() {
        UserDefaultKey.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
}

extension DefaultHaebitConfigRepository: LightMeterPreferenceProvidable {
    var apertures: [ApertureValue] { apertureEntries.filter { $0.isActive }.map { $0.value } }
    var shutterSpeeds: [ShutterSpeedValue] { shutterSpeedEntries.filter { $0.isActive }.map { $0.value } }
    var isoValues: [IsoValue] { isoEntries.filter { $0.isActive }.map { $0.value } }
    var focalLengths: [FocalLengthValue] { focalLengthEntries.filter { $0.isActive }.map { $0.value } }
}

extension DefaultHaebitConfigRepository: LoggerPreferenceProvidable {}
