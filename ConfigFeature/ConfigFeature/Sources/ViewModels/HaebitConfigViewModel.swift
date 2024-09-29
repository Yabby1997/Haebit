//
//  HaebitConfigViewModel.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/29/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

@MainActor
final class HaebitConfigViewModel: ObservableObject {
    @Published var apertures: [ApertureValue] = [.init(1.4), .init(2)].compactMap { $0 }
    @Published var shutterSpeeds: [ShutterSpeedValue] = [.init(denominator: 2000)].compactMap { $0 }
    @Published var isoValues: [IsoValue] = [.init(100), .init(200), .init(400), .init(800)].compactMap { $0 }
    @Published var focalLenghts: [FocalLengthValue] = [.init(50)].compactMap { $0 }
    @Published var apertureRingFeedbackStyle: FeedbackStyle = .heavy
    @Published var shutterSpeedDialFeedbackStyle: FeedbackStyle = .heavy
    @Published var isoDialFeedbackStyle: FeedbackStyle = .heavy
    @Published var focalLengthRingFeedbackStyle: FeedbackStyle = .soft
    @Published var perforationShape: PerforationShape = .ks
    @Published var filmCanister: FilmCanister = .kodakUltramax400
    let appVersion: String = "1.4.0"
    let isLatestVersion: Bool = true
}
