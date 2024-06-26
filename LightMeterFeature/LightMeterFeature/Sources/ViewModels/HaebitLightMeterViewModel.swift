//
//  HaebitLightMeterViewModel.swift
//  Haebit
//
//  Created by Seunghun on 11/29/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import AVFAudio
@preconcurrency import Combine
import HaebitCommonModels
import LightMeter
import Obscura
import Portolan
@preconcurrency import QuartzCore

public final class HaebitLightMeterViewModel: HaebitLightMeterViewModelProtocol {
    // MARK: - Dependencies
    
    private let camera = ObscuraCamera()
    private let logger: HaebitLightMeterLoggable
    private let portolan = PortolanLocationManager()
    private let statePersistence: LightMeterStatePersistenceProtocol
    private let reviewRequestValidator: ReviewRequestValidatable
    private let gpsAccessValidator: GPSAccessValidatable
    private let feedbackProvider: LightMeterFeedbackProvidable
    private let debounceQueue = DispatchQueue.global()
    nonisolated public let previewLayer: CALayer
    
    // MARK: - Constants
    
    nonisolated private let availableApertureValues: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    nonisolated private let availableShutterSpeedDenominators: [UInt32] = [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2]
    nonisolated private let availableShutterSpeedNumerators: [UInt32] = [1, 2, 4, 8, 16, 30, 60]
    nonisolated private let availableIsoValues: [UInt32] = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200]
    nonisolated private let availableFocalLengths: [UInt32] = [28, 35, 40, 50, 70, 85, 100, 135, 170, 200]
    
    // MARK: - Properties
    
    public var resultDescription: String {
        switch lightMeterMode {
        case .aperture: return aperture.description
        case .shutterSpeed: return shutterSpeed.description
        case .iso: return iso.description
        }
    }
    
    public var apertureMode: Bool { lightMeterMode == .aperture }
    public var shutterSpeedMode: Bool { lightMeterMode == .shutterSpeed }
    public var isoMode: Bool { lightMeterMode == .iso }
    @Published public var shouldRequestReview = false
    @Published public var isPresentingLogger = false
    @Published public var shouldRequestCameraAccess = false
    @Published public var shouldRequestGPSAccess = false
    @Published public private(set) var exposureValue: Float = .zero
    @Published public var lightMeterMode: LightMeterMode { didSet { feedbackProvider.generateInteractionFeedback() } }
    @Published public var apertureValues: [ApertureValue] = []
    @Published public var shutterSpeedValues: [ShutterSpeedValue] = []
    @Published public var isoValues: [IsoValue] = []
    @Published public var focalLengthValues: [FocalLengthValue] = []
    @Published public var aperture: ApertureValue
    @Published public var shutterSpeed: ShutterSpeedValue
    @Published public var iso: IsoValue
    @Published public var focalLength: FocalLengthValue
    @Published public var lockPoint: CGPoint? = nil
    @Published public var isLocked: Bool = false
    @Published public private(set) var isCapturing = false
    @Published private var location: Coordinate? = nil
    @Published private var isCameraRunning = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    public init(
        logger: HaebitLightMeterLoggable,
        statePersistence: LightMeterStatePersistenceProtocol,
        reviewRequestValidator: ReviewRequestValidatable,
        gpsAccessValidator: GPSAccessValidatable,
        feedbackProvider: LightMeterFeedbackProvidable
    ) {
        self.logger = logger
        self.statePersistence = statePersistence
        self.reviewRequestValidator = reviewRequestValidator
        self.gpsAccessValidator = gpsAccessValidator
        self.feedbackProvider = feedbackProvider
        previewLayer = camera.previewLayer
        lightMeterMode = statePersistence.mode
        aperture = statePersistence.aperture
        shutterSpeed = statePersistence.shutterSpeed
        iso = statePersistence.iso
        focalLength = statePersistence.focalLength
        apertureValues = availableApertureValues.compactMap { ApertureValue($0) }
        shutterSpeedValues = availableShutterSpeedDenominators.compactMap { ShutterSpeedValue(denominator: $0) } + availableShutterSpeedNumerators.compactMap { ShutterSpeedValue(numerator: $0) }
        isoValues = availableIsoValues.compactMap { IsoValue($0) }
        focalLengthValues = filterFocalLengths(with: 10)
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        cancellables = []
        
        reviewRequestValidator.shouldRequestReviewPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$shouldRequestReview)
        
        gpsAccessValidator.shouldAskGPSAccessPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$shouldRequestGPSAccess)

        $focalLength
            .sink { [weak self] focalLength in
                try? self?.zoomCamera(factor: focalLength.zoomFactor)
            }
            .store(in: &cancellables)
        
        $exposureValue.combineLatest($shutterSpeed, $aperture)
            .removeDuplicates { $0 == $1 }
            .debounce(for: .seconds(0.1), scheduler: debounceQueue)
            .filter { [weak self] _ in
                self?.lightMeterMode == .iso
                && self?.isCapturing == false
                && self?.isPresentingLogger == false
            }
            .compactMap { [weak self] ev, shutterSpeed, aperture in
                guard let self else { return nil }
                let iso = try? LightMeterService.getIsoValue(
                    ev: ev,
                    shutterSpeed: shutterSpeed.value,
                    aperture: aperture.value
                )
                    .nearest(among: isoValues.map { Float($0.value) } )
                return isoValues.first { Float($0.value) == iso }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$iso)
        
        $exposureValue.combineLatest($iso, $aperture)
            .removeDuplicates { $0 == $1 }
            .debounce(for: .seconds(0.1), scheduler: debounceQueue)
            .filter { [weak self] _ in
                self?.lightMeterMode == .shutterSpeed
                && self?.isCapturing == false
                && self?.isPresentingLogger == false
            }
            .compactMap { [weak self] ev, iso, aperture in
                guard let self else { return nil }
                let value = try? LightMeterService.getShutterSpeedValue(
                    ev: ev,
                    iso: Float(iso.value),
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
                && self?.isCapturing == false
                && self?.isPresentingLogger == false
            }
            .compactMap { [weak self] ev, iso, shutterSpeed in
                guard let self else { return nil }
                let aperture = try? LightMeterService.getApertureValue(
                    ev: ev,
                    iso: Float(iso.value),
                    shutterSpeed: shutterSpeed.value
                )
                    .nearest(among: apertureValues.map { $0.value } )
                return apertureValues.first { $0.value == aperture }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$aperture)
        
        $isLocked
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { [weak self] _ in
                self?.feedbackProvider.generateCompletionFeedback()
            }
            .store(in: &cancellables)
        
        portolan.currentLocationPublisher
            .receive(on: DispatchQueue.main)
            .map { $0?.coordinate }
            .assign(to: &$location)
        
        Task {
            await camera.isRunning
                .receive(on: DispatchQueue.main)
                .assign(to: &$isCameraRunning)
            
            await camera.maxZoomFactor
                .receive(on: DispatchQueue.main)
                .compactMap { [weak self] maxZoomFactor in
                    self?.filterFocalLengths(with: maxZoomFactor)
                }
                .assign(to: &$focalLengthValues)
            
            await camera.iso.combineLatest(camera.shutterSpeed, camera.aperture)
                .removeDuplicates { $0 == $1 }
                .debounce(for: .seconds(0.1), scheduler: debounceQueue)
                .compactMap { iso, shutterSpeed, aperture in
                    try? LightMeterService.getExposureValue(
                        iso: iso,
                        shutterSpeed: shutterSpeed,
                        aperture: aperture
                    )
                }
                .removeDuplicates()
                .receive(on: DispatchQueue.main)
                .assign(to: &$exposureValue)
            
            await camera.isExposureLocked.combineLatest(await camera.isFocusLocked)
                .map { $0 == $1 && $0 }
                .receive(on: DispatchQueue.main)
                .assign(to: &$isLocked)
            
            await camera.exposureLockPoint.combineLatest(await camera.focusLockPoint)
                .filter { $0 == $1 }
                .map { $0.0 }
                .receive(on: DispatchQueue.main)
                .assign(to: &$lockPoint)
            
            await camera.isExposureLocked.combineLatest(camera.isFocusLocked)
                .debounce(for: .seconds(1.5), scheduler: debounceQueue)
                .filter { $0 == $1 && $0 }
                .map { _ in nil }
                .receive(on: DispatchQueue.main)
                .assign(to: &$lockPoint)
        }
    }
    
    private func zoomCamera(factor: CGFloat) throws {
        Task {
            try? await camera.zoom(factor: factor)
        }
    }
    
    private func filterFocalLengths(with maxZoomFactor: CGFloat) -> [FocalLengthValue] {
        availableFocalLengths.compactMap { FocalLengthValue($0) }.filter { $0.zoomFactor <= maxZoomFactor }
    }
    
    // MARK: - Internal Methods
    
    public func setupIfNeeded() {
        setupCameraIfNeeded()
        setupLocationManagerIfNeeded()
    }
    
    private func setupCameraIfNeeded() {
        guard isCameraRunning == false else {
            return
        }
        Task {
            do {
                try await camera.setup()
                try? await camera.setHDRMode(isEnabled: false)
                bind()
            } catch {
                if case .notAuthorized = error as? ObscuraCamera.Errors {
                    shouldRequestCameraAccess = true
                }
            }
        }
    }
    
    private func setupLocationManagerIfNeeded() {
        Task {
            do {
                try portolan.setup()
                gpsAccessValidator.isAccessAuthorized = true
            } catch {
                if case .notAuthorized = error as? PortolanLocationManager.Errors {
                    gpsAccessValidator.isAccessAuthorized = false
                }
            }
        }
    }
    
    public func prepareInactive() {
        statePersistence.mode = lightMeterMode
        statePersistence.aperture = aperture
        statePersistence.shutterSpeed = shutterSpeed
        statePersistence.iso = iso
        statePersistence.focalLength = focalLength
    }
    
    public func didTap(point: CGPoint) {
        Task {
            try await camera.lockExposure(on: point)
            try await camera.lockFocus(on: point)
            feedbackProvider.generateInteractionFeedback()
        }
    }
    
    public func didTapUnlock() {
        Task {
            try await camera.unlockExposure()
            try await camera.unlockFocus()
            feedbackProvider.generateInteractionFeedback()
        }
    }
    
    public func didTapShutter() {
        isCapturing = true
        Task {
            guard let captured = try? await camera.capturePhoto() else { return }
            do {
                try await logger.save(
                    date: Date(),
                    latitude: location?.latitude,
                    longitude: location?.longitude,
                    image: captured.imagePath,
                    focalLength: focalLength.value,
                    iso: iso.value,
                    shutterSpeedNumerator: shutterSpeed.numerator,
                    shutterSpeedDenominator: shutterSpeed.denominator,
                    aperture: aperture.value,
                    memo: ""
                )
                isCapturing = false
            } catch {
                isCapturing = false
            }
        }
    }
    
    public func didTapDoNotAskGPSAccess() {
        gpsAccessValidator.requestDoNotAsk()
    }
    
    public func didTapLogger() {
        isPresentingLogger = true
        feedbackProvider.generateInteractionFeedback()
        Task {
            await camera.stop()
        }
    }
    
    public func didCloseLogger() {
        isPresentingLogger = false
        feedbackProvider.generateInteractionFeedback()
        Task {
            await camera.start()
            try? AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
        }
    }
}

extension PortolanCoordinate {
    var coordinate: Coordinate? {
        .init(latitude: latitude, longitude: longitude)
    }
}
