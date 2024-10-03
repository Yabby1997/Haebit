//
//  HaebitConfigViewModel.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/29/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import HaebitCommonModels

@MainActor
final class HaebitConfigViewModel: ObservableObject {
    private let configRepository: any HaebitConfigRepository
    private let appStoreOpener: any AppStoreOpener
    private let appVersionProvider: any AppVersionProvidable
    @Published var currentHeaderType: HeaderType = .tipJar
    @Published var apertureEntries: [ApertureEntry]
    @Published var shutterSpeedEntries: [ShutterSpeedEntry]
    @Published var isoEntries: [IsoEntry]
    @Published var focalLengthEntries: [FocalLengthEntry]
    @Published var apertureRingFeedbackStyle: FeedbackStyle
    @Published var shutterSpeedDialFeedbackStyle: FeedbackStyle
    @Published var isoDialFeedbackStyle: FeedbackStyle
    @Published var focalLengthRingFeedbackStyle: FeedbackStyle
    @Published var perforationShape: PerforationShape
    @Published var filmCanister: FilmCanister
    @Published var apertures: [ApertureValue] = []
    @Published var shutterSpeeds: [ShutterSpeedValue] = []
    @Published var isoValues: [IsoValue] = []
    @Published var focalLengths: [FocalLengthValue] = []
    @Published var isLatestVersion: Bool = false
    @Published var appVersion: String = "1.0.0"
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(
        configRepository: any HaebitConfigRepository,
        appStoreOpener: any AppStoreOpener,
        appVersionProvider: any AppVersionProvidable
    ) {
        self.configRepository = configRepository
        self.appStoreOpener = appStoreOpener
        self.appVersionProvider = appVersionProvider
        apertureEntries = configRepository.apertureEntries
        shutterSpeedEntries = configRepository.shutterSpeedEntries
        isoEntries = configRepository.isoEntries
        focalLengthEntries = configRepository.focalLengthEntries
        apertureRingFeedbackStyle = configRepository.apertureRingFeedbackStyle
        shutterSpeedDialFeedbackStyle = configRepository.shutterSpeedDialFeedbackStyle
        isoDialFeedbackStyle = configRepository.isoDialFeedbackStyle
        focalLengthRingFeedbackStyle = configRepository.focalLengthRingFeedbackStyle
        perforationShape = configRepository.perforationShape
        filmCanister = configRepository.filmCanister
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
        
        $apertureEntries
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] entries in
                self?.configRepository.apertureEntries = entries
            }
            .store(in: &cancellables)
        
        $shutterSpeedEntries
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] entries in
                self?.configRepository.shutterSpeedEntries = entries
            }
            .store(in: &cancellables)
        
        $isoEntries
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] entries in
                self?.configRepository.isoEntries = entries
            }
            .store(in: &cancellables)
        
        $focalLengthEntries
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] entries in
                self?.configRepository.focalLengthEntries = entries
            }
            .store(in: &cancellables)
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
        entry.isActive == false || isDeletable(aperture: entry)
    }
    
    func isToggleable(shutterSpeed entry: ShutterSpeedEntry) -> Bool {
        entry.isActive == false || isDeletable(shutterSpeed: entry)
    }
    
    func isToggleable(iso entry: IsoEntry) -> Bool {
        entry.isActive == false || isDeletable(iso: entry)
    }
    
    func isToggleable(focalLength entry: FocalLengthEntry) -> Bool {
        entry.isActive == false || isDeletable(focalLength: entry)
    }
    
    func isDeletable(aperture entry: ApertureEntry) -> Bool {
        let minimumEntryCount = (shutterSpeeds.count == 1 && isoValues.count == 1) ? 2 : 1
        return apertureEntries.filter { $0 != entry }.count { $0.isActive } >= minimumEntryCount
    }
    
    func isDeletable(shutterSpeed entry: ShutterSpeedEntry) -> Bool {
        let minimumEntryCount = (apertures.count == 1 && isoValues.count == 1) ? 2 : 1
        return shutterSpeedEntries.filter { $0 != entry }.count { $0.isActive } >= minimumEntryCount
    }
    
    func isDeletable(iso entry: IsoEntry) -> Bool {
        let minimumEntryCount = (apertures.count == 1 && shutterSpeeds.count == 1) ? 2 : 1
        return isoEntries.filter { $0 != entry }.count { $0.isActive } >= minimumEntryCount
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