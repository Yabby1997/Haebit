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
import Portolan
@preconcurrency import QuartzCore

@MainActor
public final class HaebitLightMeterViewModel: ObservableObject {
    // MARK: - Dependencies
    
    private let camera: LightMeterCamera
    private let logger: HaebitLightMeterLoggable
    private let preferenceProvider: LightMeterPreferenceProvidable
    private let portolan = PortolanLocationManager()
    private let statePersistence: LightMeterStatePersistenceProtocol
    private let reviewRequestValidator: ReviewRequestValidatable
    private let gpsAccessValidator: GPSAccessValidatable
    private let feedbackProvider: LightMeterFeedbackProvidable
    private let debounceQueue = DispatchQueue.global()
    nonisolated public let previewLayer: CALayer
    
    // MARK: - Properties
    
    public var resultDescription: String {
        switch lightMeterMode {
        case .aperture: return aperture.description
        case .shutterSpeed: return shutterSpeed.description
        case .iso: return iso.description
        }
    }
    
    public var constantsDescription: String {
        [
            isApertureFixed ? aperture.description : nil,
            isShutterSpeedFixed ? shutterSpeed.description : nil,
            isIsoFixed ? iso.description : nil,
            isFocalLengthFixed ? focalLength.title : nil
        ]
        .compactMap { $0 }
        .joined(separator: " ")
    }
    
    public var apertureMode: Bool { lightMeterMode == .aperture }
    public var shutterSpeedMode: Bool { lightMeterMode == .shutterSpeed }
    public var isoMode: Bool { lightMeterMode == .iso }
    @Published public var isApertureFixed = false
    @Published public var isShutterSpeedFixed = false
    @Published public var isIsoFixed = false
    @Published public var isFocalLengthFixed = false
    @Published public var shouldRequestReview = false
    @Published public var isPresentingLogger = false
    @Published public var shouldRequestCameraAccess = false
    @Published public var shouldRequestGPSAccess = false
    @Published public private(set) var exposureValue: Float = .zero
    @Published public var lightMeterMode: LightMeterMode
    @Published public var apertureValues: [ApertureValue] = []
    @Published public var shutterSpeedValues: [ShutterSpeedValue] = []
    @Published public var isoValues: [IsoValue] = []
    @Published public var focalLengthValues: [FocalLengthValue] = []
    @Published public var aperture: ApertureValue
    @Published public var shutterSpeed: ShutterSpeedValue
    @Published public var iso: IsoValue
    @Published public var focalLength: FocalLengthValue
    @Published public var apertureRingFeedbackStyle: FeedbackStyle = .light
    @Published public var shutterSpeedRingFeedbackStyle: FeedbackStyle = .light
    @Published public var isoRingFeedbackStyle: FeedbackStyle = .light
    @Published public var focalRingFeedbackStyle: FeedbackStyle = .light
    @Published public var lockPoint: CGPoint? = nil
    @Published public var isLocked: Bool = false
    @Published public private(set) var isCapturing = false
    @Published private var location: Coordinate? = nil
    @Published private var isCameraRunning = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    public init(
        camera: LightMeterCamera,
        logger: HaebitLightMeterLoggable,
        preferenceProvider: LightMeterPreferenceProvidable,
        statePersistence: LightMeterStatePersistenceProtocol,
        reviewRequestValidator: ReviewRequestValidatable,
        gpsAccessValidator: GPSAccessValidatable,
        feedbackProvider: LightMeterFeedbackProvidable = LightMeterHapticFeedbackProvider()
    ) {
        self.camera = camera
        self.logger = logger
        self.statePersistence = statePersistence
        self.reviewRequestValidator = reviewRequestValidator
        self.gpsAccessValidator = gpsAccessValidator
        self.feedbackProvider = feedbackProvider
        self.preferenceProvider = preferenceProvider
        previewLayer = camera.previewLayer
        lightMeterMode = statePersistence.mode
        aperture = statePersistence.aperture
        shutterSpeed = statePersistence.shutterSpeed
        iso = statePersistence.iso
        focalLength = statePersistence.focalLength
        bind()
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        cancellables = []
        
        preferenceProvider.apertureValues
            .receive(on: DispatchQueue.main)
            .assign(to: &$apertureValues)
        
        preferenceProvider.shutterSpeedValues
            .receive(on: DispatchQueue.main)
            .assign(to: &$shutterSpeedValues)
        
        preferenceProvider.isoValues
            .receive(on: DispatchQueue.main)
            .assign(to: &$isoValues)
        
        preferenceProvider.apertureRingFeedbackStyle
            .receive(on: DispatchQueue.main)
            .assign(to: &$apertureRingFeedbackStyle)
        
        preferenceProvider.shutterSpeedRingFeedbackStyle
            .receive(on: DispatchQueue.main)
            .assign(to: &$shutterSpeedRingFeedbackStyle)
        
        preferenceProvider.isoRingFeedbackStyle
            .receive(on: DispatchQueue.main)
            .assign(to: &$isoRingFeedbackStyle)
        
        $isCameraRunning.combineLatest(preferenceProvider.apertureValues)
            .filter { $0.0 }
            .compactMap { [weak self] _, apertureValues in
                guard let value = self?.aperture.value else { return nil }
                return apertureValues.first { $0.value == value.nearest(among: apertureValues.map { $0.value }) }
            }
            .assign(to: &$aperture)
        
        $isCameraRunning.combineLatest(preferenceProvider.shutterSpeedValues)
            .filter { $0.0 }
            .compactMap { [weak self] _, shutterSpeedValues in
                guard let value = self?.shutterSpeed.value else { return nil }
                return shutterSpeedValues.first { $0.value == value.nearest(among: shutterSpeedValues.map { $0.value }) }
            }
            .assign(to: &$shutterSpeed)
        
        $isCameraRunning.combineLatest(preferenceProvider.isoValues)
            .filter { $0.0 }
            .compactMap { [weak self] _, isoValues in
                guard let self else { return nil }
                let value = Float(iso.value)
                return isoValues.first { Float($0.value) == value.nearest(among: isoValues.compactMap { Float($0.value) }) }
            }
            .assign(to: &$iso)
        
        preferenceProvider.focalLengthValues.combineLatest(camera.maxZoomFactor)
            .map { focalLengthValues, maxZoomFactor in
                focalLengthValues.filter { $0.zoomFactor <= maxZoomFactor }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$focalLengthValues)
        
        reviewRequestValidator.shouldRequestReviewPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$shouldRequestReview)
        
        gpsAccessValidator.shouldAskGPSAccessPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$shouldRequestGPSAccess)
        
        $lightMeterMode
            .removeDuplicates()
            .sink { [weak self] _ in
                self?.feedbackProvider.generateCompletionFeedback()
            }
            .store(in: &cancellables)
        
        $isCameraRunning.combineLatest($exposureValue, $iso, $shutterSpeed)
            .removeDuplicates { $0 == $1 }
            .filter { $0.0 }
            .map { ($0.1, $0.2, $0.3) }
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
        
        $isCameraRunning.combineLatest($exposureValue, $iso, $aperture)
            .removeDuplicates { $0 == $1 }
            .filter { $0.0 }
            .map { ($0.1, $0.2, $0.3) }
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
        
        $isCameraRunning.combineLatest($exposureValue, $shutterSpeed, $aperture)
            .removeDuplicates { $0 == $1 }
            .filter { $0.0 }
            .map { ($0.1, $0.2, $0.3) }
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
        
        $focalLength
            .sink { [weak self] focalLength in
                try? self?.zoomCamera(factor: focalLength.zoomFactor)
            }
            .store(in: &cancellables)
        
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
        
        camera.isRunning
            .receive(on: DispatchQueue.main)
            .assign(to: &$isCameraRunning)
        
        camera.iso.combineLatest(camera.shutterSpeed, camera.aperture)
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
        
        $apertureValues
            .map { $0.count == 1 }
            .assign(to: &$isApertureFixed)
        
        $shutterSpeedValues
            .map { $0.count == 1 }
            .assign(to: &$isShutterSpeedFixed)
        
        $isoValues
            .map { $0.count == 1 }
            .assign(to: &$isIsoFixed)
        
        $focalLengthValues
            .map { $0.count == 1 }
            .assign(to: &$isFocalLengthFixed)
        
        $isApertureFixed.combineLatest($isShutterSpeedFixed, $isIsoFixed)
            .filter { [weak self] in
                guard let self else { return false }
                return ($0 && lightMeterMode == .aperture)
                    || ($1 && lightMeterMode == .shutterSpeed)
                    || ($2 && lightMeterMode == .iso)
            }
            .compactMap { [weak self] _ -> LightMeterMode? in
                guard let self else { return nil }
                return isApertureFixed
                    ? isShutterSpeedFixed
                        ? .iso
                        : .shutterSpeed
                    : .aperture
            }
            .assign(to: &$lightMeterMode)
    }
    
    private func zoomCamera(factor: CGFloat) throws {
        Task {
            try? await camera.zoom(factor: factor)
        }
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
            } catch {
                if case .notAuthorized = error as? LightMeterCameraErrors {
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
            guard let imagePath = try? await camera.capturePhoto() else { return }
            do {
                try await logger.save(
                    date: Date(),
                    latitude: location?.latitude,
                    longitude: location?.longitude,
                    image: imagePath,
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
