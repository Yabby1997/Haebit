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

final class HaebitLightMeterViewModel: HaebitLightMeterViewModelProtocol {
    // MARK: - Dependencies
    
    private let camera = ObscuraCamera()
    private let lightMeter = LightMeterService()
    private let statePersistence: LightMeterStatePersistenceProtocol
    private let reviewRequestValidator: ReviewRequestValidatable
    private let feedbackProvider: LightMeterFeedbackProvidable
    private let debounceQueue = DispatchQueue.global()
    var previewLayer: CALayer { camera.previewLayer }
    
    // MARK: - Constants
    
    private let availableApertureValues: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    private let availableShutterSpeedDenominators: [Float] = [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2, 1, 0.5, 0.25, 0.125, 0.0625, 0.03333333, 0.01666666]
    private let availableIsoValues: [Int] = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200]
    private let availableFocalLengths: [Int] = [28, 35, 40, 50, 70, 85, 100, 135, 170, 200]
    
    // MARK: - Properties
    
    lazy var apertureValues: [ApertureValue] = { availableApertureValues.map { ApertureValue(value: $0) } }()
    lazy var shutterSpeedValues: [ShutterSpeedValue] = { availableShutterSpeedDenominators.map { ShutterSpeedValue(denominator: $0) } }()
    lazy var isoValues: [IsoValue] = { availableIsoValues.map { IsoValue(iso: $0) } }()
    lazy var focalLengths: [FocalLengthValue] = { availableFocalLengths.map { FocalLengthValue(value: $0) }.filter { $0.zoomFactor <= camera.maxZoomFactor } }()
    
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
    @Published var shouldRequestReview = false
    
    @Published var shouldRequestCameraAccess = false
    @Published private(set) var exposureValue: Float = .zero
    @Published var lightMeterMode: LightMeterMode { didSet { feedbackProvider.generateInteractionFeedback() } }
    @Published var aperture: ApertureValue
    @Published var shutterSpeed: ShutterSpeedValue
    @Published var iso: IsoValue
    @Published var focalLength: FocalLengthValue
    @Published var lockPoint: CGPoint? = nil
    @Published var isLocked: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    init(
        statePersistence: LightMeterStatePersistenceProtocol,
        reviewRequestValidator: ReviewRequestValidatable,
        feedbackProvider: LightMeterFeedbackProvidable
    ) {
        self.statePersistence = statePersistence
        self.reviewRequestValidator = reviewRequestValidator
        self.feedbackProvider = feedbackProvider
        self.lightMeterMode = statePersistence.mode
        self.aperture = statePersistence.aperture
        self.shutterSpeed = statePersistence.shutterSpeed
        self.iso = statePersistence.iso
        self.focalLength = statePersistence.focalLength
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        cancellables = []
        
        reviewRequestValidator.shouldRequestReview
            .receive(on: DispatchQueue.main)
            .assign(to: &$shouldRequestReview)

        $focalLength
            .sink { [weak self] focalLength in
                try? self?.camera.zoom(factor: focalLength.zoomFactor)
            }
            .store(in: &cancellables)
        
        camera.iso.combineLatest(camera.shutterSpeed, camera.aperture)
            .removeDuplicates { $0 == $1 }
            .debounce(for: .seconds(0.1), scheduler: debounceQueue)
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
            .removeDuplicates { $0 == $1 }
            .debounce(for: .seconds(0.1), scheduler: debounceQueue)
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
            .removeDuplicates { $0 == $1 }
            .debounce(for: .seconds(0.1), scheduler: debounceQueue)
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
            .removeDuplicates { $0 == $1 }
            .debounce(for: .seconds(0.1), scheduler: debounceQueue)
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
            .receive(on: DispatchQueue.main)
            .assign(to: &$lockPoint)
        
        camera.isExposureLocked.combineLatest(camera.isFocusLocked)
            .debounce(for: .seconds(1.5), scheduler: debounceQueue)
            .filter { $0 == $1 && $0 }
            .map { _ in nil }
            .receive(on: DispatchQueue.main)
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
    
    func setupIfNeeded() async {
        guard !camera.isRunning else { return }
        do {
            try await camera.setup()
            try? camera.setHDRMode(isEnabled: false)
            bind()
        } catch {
            guard case .notAuthorized = error as? ObscuraCamera.Errors else { return }
            Task { @MainActor in
                shouldRequestCameraAccess = true
            }
        }
    }
    
    func prepareInactive() {
        statePersistence.mode = lightMeterMode
        statePersistence.aperture = aperture
        statePersistence.shutterSpeed = shutterSpeed
        statePersistence.iso = iso
        statePersistence.focalLength = focalLength
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
