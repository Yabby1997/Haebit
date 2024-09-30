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
    private let appStoreOpener: any AppStoreOpener
    private let appVersionProvider: any AppVersionProvidable
    @Published var currentHeaderType: HeaderType = .tipJar
    @Published var apertureEntries: [ApertureEntry] = [
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
    @Published var apertures: [ApertureValue] = []
    @Published var shutterSpeeds: [ShutterSpeedValue] = [.init(denominator: 2000)].compactMap { $0 }
    @Published var isoValues: [IsoValue] = [.init(100), .init(200), .init(400), .init(800)].compactMap { $0 }
    @Published var focalLenghts: [FocalLengthValue] = [.init(50)].compactMap { $0 }
    @Published var apertureRingFeedbackStyle: FeedbackStyle = .heavy
    @Published var shutterSpeedDialFeedbackStyle: FeedbackStyle = .heavy
    @Published var isoDialFeedbackStyle: FeedbackStyle = .heavy
    @Published var focalLengthRingFeedbackStyle: FeedbackStyle = .soft
    @Published var perforationShape: PerforationShape = .ks
    @Published var filmCanister: FilmCanister = .kodakUltramax400
    @Published var isLatestVersion: Bool = false
    @Published var appVersion: String = "1.0.0"
    
    init(
        appStoreOpener: any AppStoreOpener,
        appVersionProvider: any AppVersionProvidable
    ) {
        self.appStoreOpener = appStoreOpener
        self.appVersionProvider = appVersionProvider
        bind()
    }
    
    private func bind() {
        Timer.publish(every: 10, on: .main, in: .default)
            .autoconnect()
            .combineLatest($currentHeaderType)
            .map { $1.next }
            .assign(to: &$currentHeaderType)
        
        $apertureEntries
            .map { $0.filter { $0.isActive }.map { $0.value } }
            .assign(to: &$apertures)
    }
    
    func onAppear() {
        Task {
            appVersion = await appVersionProvider.currentVersion
            isLatestVersion = (try? await appVersionProvider.checkLatestVersion()) == appVersion
        }
    }
    
    func didTapReview() {
        appStoreOpener.openWriteReview()
    }
    
    func didTapAppVersion() {
        appStoreOpener.openAppPage()
    }
    
    func isToggleable(aperture entry: ApertureEntry) -> Bool {
        entry.isActive == false || apertureEntries.filter { $0 != entry }.count { $0.isActive } > .zero
    }
    
    func isDeletable(aperture entry: ApertureEntry) -> Bool {
        apertureEntries.filter { $0 != entry }.count { $0.isActive } > .zero
    }
    
    func deleteApertures(at offsets: IndexSet) {
        apertureEntries.remove(atOffsets: offsets)
    }
}
