//
//  HaebitLightMeterViewModel.swift
//  Haebit
//
//  Created by Seunghun on 11/29/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Combine
import LightMeter
import Obscura
import QuartzCore

final class HaebitLightMeterViewModel: ObservableObject {
    // MARK: - Dependencies
    
    private let camera = ObscuraCamera()
    private let lightMeter = LightMeterService()
    private let feedbackProvider: HaebitLightMeterFeedbackProvidable
    var previewLayer: CALayer { camera.previewLayer }
    
    // MARK: - Constants
    
    private let availableApertureValues: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    private let availableShutterSpeedDenominators: [Int] = [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2, 1]
    private let availableIsoValues: [Int] = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200]
    
    // MARK: - Properties
    
    var apertureValues: [ApertureValue] { availableApertureValues.map { ApertureValue(value: $0) } }
    var shutterSpeedValues: [ShutterSpeedValue] { availableShutterSpeedDenominators.map { ShutterSpeedValue(denominator: $0) } }
    var isoValues: [IsoValue] { availableIsoValues.map { IsoValue(iso: $0) } }
    var resultDescription: String {
        switch lightMeterMode {
        case .aperture: return aperture.description
        case .shutterSpeed: return shutterSpeed.description
        case .iso: return iso.description
        }
    }
    
    var apertureMode: Bool { lightMeterMode == .aperture }
    var shutterSpeedMode: Bool { lightMeterMode == .shutterSpeed }
    var isoMode: Bool { lightMeterMode == .iso }
    
    @Published var shouldRequestCameraAccess = false
    @Published private(set) var exposureValue: Float = .zero
    @Published var lightMeterMode: LightMeterMode = .shutterSpeed { didSet { feedbackProvider.generateInteractionFeedback() } }
    @Published var aperture: ApertureValue = ApertureValue(value: 1.4)
    @Published var shutterSpeed: ShutterSpeedValue = ShutterSpeedValue(denominator: 60)
    @Published var iso: IsoValue = IsoValue(iso: 200)
    @Published var lockPoint: CGPoint? = nil
    @Published var isLocked: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    init(feedbackProvider: HaebitLightMeterFeedbackProvidable) {
        self.feedbackProvider = feedbackProvider
        bind()
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        camera.iso.combineLatest(camera.shutterSpeed, camera.aperture)
            .compactMap { [weak self] iso, shutterSpeed, aperture in
                try? self?.lightMeter.getExposureValue(
                    iso: iso,
                    shutterSpeed: shutterSpeed,
                    aperture: aperture
                )
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$exposureValue)
        
        $exposureValue.combineLatest($shutterSpeed, $aperture)
            .filter { [weak self] _ in
                self?.lightMeterMode == .iso
            }
            .compactMap { [weak self] ev, shutterSpeed, aperture in
                guard let self else { return nil }
                let iso = try? lightMeter.getIsoValue(
                    ev: ev,
                    shutterSpeed: shutterSpeed.value,
                    aperture: aperture.value
                )
                    .nearest(among: isoValues.map { $0.value } )
                return isoValues.first { $0.value == iso }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$iso)
        
        $exposureValue.combineLatest($iso, $aperture)
            .filter { [weak self] _ in
                self?.lightMeterMode == .shutterSpeed
            }
            .compactMap { [weak self] ev, iso, aperture in
                guard let self else { return nil }
                let value = try? lightMeter.getShutterSpeedValue(
                    ev: ev,
                    iso: iso.value,
                    aperture: aperture.value
                )
                .nearest(among: shutterSpeedValues.map { $0.value } )
                return shutterSpeedValues.first { $0.value == value }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$shutterSpeed)
        
        $exposureValue.combineLatest($iso, $shutterSpeed)
            .filter { [weak self] _ in
                self?.lightMeterMode == .aperture
            }
            .compactMap { [weak self] ev, iso, shutterSpeed in
                guard let self else { return nil }
                let aperture = try? lightMeter.getApertureValue(
                    ev: ev,
                    iso: iso.value,
                    shutterSpeed: shutterSpeed.value
                )
                    .nearest(among: apertureValues.map { $0.value } )
                return apertureValues.first { $0.value == aperture }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$aperture)
        
        camera.isExposureLocked.combineLatest(camera.isFocusLocked)
            .map { $0 == $1 && $0 }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLocked)
        
        camera.exposureLockPoint.combineLatest(camera.focusLockPoint)
            .filter { $0 == $1 }
            .map { $0.0 }
            .assign(to: &$lockPoint)
        
        camera.isExposureLocked.combineLatest(camera.isFocusLocked)
            .debounce(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .filter { $0 == $1 && $0 }
            .map { _ in nil }
            .assign(to: &$lockPoint)
        
        $isLocked
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { [weak self] _ in
                self?.feedbackProvider.generateCompletionFeedback()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Internal Methods

    func setupIfNeeded() {
        Task {
            do {
                try await camera.setup()
            } catch {
                Task { @MainActor in
                    shouldRequestCameraAccess = true
                }
            }
        }
    }
    
    func didTap(point: CGPoint) {
        do {
            try camera.lockExposure(on: point)
            try camera.lockFocus(on: point)
            feedbackProvider.generateInteractionFeedback()
        } catch {}
    }
    
    func didTapUnlock() {
        do {
            try camera.unlockExposure()
            try camera.unlockFocus()
            feedbackProvider.generateInteractionFeedback()
        } catch {}
    }
}
