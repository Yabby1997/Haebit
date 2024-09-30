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
    @Published var shutterSpeedEntries: [ShutterSpeedEntry] = [
        .init(value: .init(denominator: 8000)!, isActive: false),
        .init(value: .init(denominator: 4000)!, isActive: false),
        .init(value: .init(denominator: 2000)!, isActive: true),
        .init(value: .init(denominator: 1000)!, isActive: true),
        .init(value: .init(denominator: 500)!, isActive: true),
        .init(value: .init(denominator: 250)!, isActive: true),
        .init(value: .init(denominator: 125)!, isActive: true),
        .init(value: .init(denominator: 60)!, isActive: true),
        .init(value: .init(denominator: 30)!, isActive: true),
        .init(value: .init(denominator: 16)!, isActive: false),
        .init(value: .init(denominator: 8)!, isActive: false),
        .init(value: .init(denominator: 4)!, isActive: false),
        .init(value: .init(denominator: 2)!, isActive: false),
        .init(value: .init(denominator: 1)!, isActive: false),
    ]
    @Published var shutterSpeeds: [ShutterSpeedValue] = []
    @Published var isoEntries: [IsoEntry] = [
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
    @Published var isoValues: [IsoValue] = []
    @Published var focalLengthEntries: [FocalLengthEntry] = [
        .init(value: .init(11)!, isActive: false),
        .init(value: .init(22)!, isActive: false),
        .init(value: .init(28)!, isActive: true),
        .init(value: .init(35)!, isActive: true),
        .init(value: .init(44)!, isActive: true),
        .init(value: .init(50)!, isActive: true),
        .init(value: .init(70)!, isActive: true),
        .init(value: .init(85)!, isActive: false),
        .init(value: .init(100)!, isActive: true),
        .init(value: .init(135)!, isActive: true),
        .init(value: .init(150)!, isActive: false),
        .init(value: .init(200)!, isActive: true),
        .init(value: .init(300)!, isActive: false),
        .init(value: .init(400)!, isActive: false),
    ]
    @Published var focalLengths: [FocalLengthValue] = []
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
        
        $shutterSpeedEntries
            .map { $0.filter { $0.isActive }.map { $0.value } }
            .assign(to: &$shutterSpeeds)
        
        $isoEntries
            .map { $0.filter { $0.isActive }.map { $0.value } }
            .assign(to: &$isoValues)
        
        $focalLengthEntries
            .map { $0.filter { $0.isActive }.map { $0.value } }
            .assign(to: &$focalLengths)
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
    
    func isToggleable(shutterSpeed entry: ShutterSpeedEntry) -> Bool {
        entry.isActive == false || shutterSpeedEntries.filter { $0 != entry }.count { $0.isActive } > .zero
    }
    
    func isToggleable(iso entry: IsoEntry) -> Bool {
        entry.isActive == false || isoEntries.filter { $0 != entry }.count { $0.isActive } > .zero
    }
    
    func isToggleable(focalLength entry: FocalLengthEntry) -> Bool {
        entry.isActive == false || focalLengthEntries.filter { $0 != entry }.count { $0.isActive } > .zero
    }
    
    func isDeletable(aperture entry: ApertureEntry) -> Bool {
        apertureEntries.filter { $0 != entry }.count { $0.isActive } > .zero
    }
    
    func isDeletable(shutterSpeed entry: ShutterSpeedEntry) -> Bool {
        shutterSpeedEntries.filter { $0 != entry }.count { $0.isActive } > .zero
    }
    
    func isDeletable(iso entry: IsoEntry) -> Bool {
        isoEntries.filter { $0 != entry }.count { $0.isActive } > .zero
    }
    
    func isDeletable(focalLength entry: FocalLengthEntry) -> Bool {
        focalLengthEntries.filter { $0 != entry }.count { $0.isActive } > .zero
    }
    
    func deleteApertures(at offsets: IndexSet) {
        apertureEntries.remove(atOffsets: offsets)
    }
    
    func deleteShutterSpeeds(at offsets: IndexSet) {
        shutterSpeedEntries.remove(atOffsets: offsets)
    }
    
    func deleteIso(at offsets: IndexSet) {
        isoEntries.remove(atOffsets: offsets)
    }
    
    func deleteFocalLength(at offsets: IndexSet) {
        focalLengthEntries.remove(atOffsets: offsets)
    }
    
    func add(aperture value: ApertureValue) {
        if let index = (apertureEntries.firstIndex { $0.value == value }) {
            apertureEntries[index].isActive = true
        } else {
            apertureEntries.append(.init(value: value, isActive: true))
            apertureEntries.sort(by: { $0.value.value < $1.value.value })
        }
    }
    
    func add(shutterSpeed value: ShutterSpeedValue) {
        if let index = (shutterSpeedEntries.firstIndex { $0.value == value }) {
            shutterSpeedEntries[index].isActive = true
        } else {
            shutterSpeedEntries.append(.init(value: value, isActive: true))
            shutterSpeedEntries.sort(by: { $0.value.value < $1.value.value })
        }
    }
    
    func add(iso value: IsoValue) {
        if let index = (isoEntries.firstIndex { $0.value == value }) {
            isoEntries[index].isActive = true
        } else {
            isoEntries.append(.init(value: value, isActive: true))
            isoEntries.sort(by: { $0.value.value < $1.value.value })
        }
    }

    func add(focalLength value: FocalLengthValue) {
        if let index = (focalLengthEntries.firstIndex { $0.value == value }) {
            focalLengthEntries[index].isActive = true
        } else {
            focalLengthEntries.append(.init(value: value, isActive: true))
            focalLengthEntries.sort(by: { $0.value.value < $1.value.value })
        }
    }
}
