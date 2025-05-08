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
    public let previewLayer: CALayer
    
    // MARK: - Properties
    
    public var resultDescription: String {
        switch lightMeterMode {
        case .aperture: return aperture.description
        case .shutterSpeed: return shutterSpeed.description
        case .iso: return iso.description
        }
    }
    
    public var fixedDescription: String {
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
    public var isFixedDescriptionVisible: Bool {
        isApertureFixed || isShutterSpeedFixed || isIsoFixed || isFocalLengthFixed
    }
    var isUnlockable: Bool { lockPoint != nil || isLocked }
    
    @Published public var isApertureFixed = false
    @Published public var isShutterSpeedFixed = false
    @Published public var isIsoFixed = false
    @Published public var isFocalLengthFixed = false
    @Published public var isExposureCompensationRingVisible = true
    @Published public var shouldRequestReview = false
    @Published public var shouldRequestCameraAccess = false
    @Published public var shouldRequestGPSAccess = false
    @Published public private(set) var exposureValue: Float = .zero
    @Published public var lightMeterMode: LightMeterMode
    @Published public var apertures: [ApertureValue]
    @Published public var shutterSpeeds: [ShutterSpeedValue]
    @Published public var isoValues: [IsoValue]
    @Published public var focalLengths: [FocalLengthValue]
    @Published public var exposureCompensationValues: [Float] =  [-2.0, -1.666, -1.333, -1.0, -0.666, -0.333, 0.0, 0.333, 0.666, 1.0, 1.333, 1.666, 2.0]
    @Published public var aperture: ApertureValue
    @Published public var shutterSpeed: ShutterSpeedValue
    @Published public var iso: IsoValue
    @Published public var focalLength: FocalLengthValue
    @Published public var exposureCompensation: Float = .zero
    @Published public var shouldShowConfigOnboarding: Bool
    @Published public var apertureRingFeedbackStyle: FeedbackStyle
    @Published public var shutterSpeedDialFeedbackStyle: FeedbackStyle
    @Published public var isoDialFeedbackStyle: FeedbackStyle
    @Published public var focalRingFeedbackStyle: FeedbackStyle
    @Published public var filmCanister: FilmCanister
    @Published public var lockPoint: CGPoint? = nil
    @Published public var isLocked: Bool = false
    @Published public private(set) var isCapturing = false
    @Published private var location: Coordinate? = nil
    @Published private var isCameraRunning = false
    @Published private var preferedFocalLengths: [FocalLengthValue]
    private let fallbackFocalLength: UInt32
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    public init(
        camera: LightMeterCamera,
        logger: HaebitLightMeterLoggable,
        preferenceProvider: LightMeterPreferenceProvidable,
        statePersistence: LightMeterStatePersistenceProtocol,
        fallbackFocalLength: UInt32 = 28,
        reviewRequestValidator: ReviewRequestValidatable,
        gpsAccessValidator: GPSAccessValidatable,
        feedbackProvider: LightMeterFeedbackProvidable = LightMeterHapticFeedbackProvider()
    ) {
        self.camera = camera
        self.logger = logger
        self.preferenceProvider = preferenceProvider
        self.statePersistence = statePersistence
        self.fallbackFocalLength = fallbackFocalLength
        self.reviewRequestValidator = reviewRequestValidator
        self.gpsAccessValidator = gpsAccessValidator
        self.feedbackProvider = feedbackProvider
        previewLayer = camera.previewLayer
        apertures = preferenceProvider.apertures
        shutterSpeeds = preferenceProvider.shutterSpeeds
        isoValues = preferenceProvider.isoValues
        preferedFocalLengths = preferenceProvider.focalLengths
        focalLengths = preferenceProvider.focalLengths
        apertureRingFeedbackStyle = preferenceProvider.apertureRingFeedbackStyle
        shutterSpeedDialFeedbackStyle = preferenceProvider.shutterSpeedDialFeedbackStyle
        isoDialFeedbackStyle = preferenceProvider.isoDialFeedbackStyle
        focalRingFeedbackStyle = preferenceProvider.focalLengthRingFeedbackStyle
        filmCanister = preferenceProvider.filmCanister
        lightMeterMode = statePersistence.mode
        aperture = statePersistence.aperture
        shutterSpeed = statePersistence.shutterSpeed
        iso = statePersistence.iso
        focalLength = statePersistence.focalLength
        shouldShowConfigOnboarding = statePersistence.shouldShowConfigOnboarding
        bind()
    }
    
    // MARK: - Private Methods
    
    private func bind() {
        cancellables = []
        
        $apertures
            .removeDuplicates()
            .compactMap { [weak self] apertures in
                guard let aperture = self?.aperture else { return nil }
                return apertures.nearest(to: aperture)
            }
            .assign(to: &$aperture)
        
        $shutterSpeeds
            .removeDuplicates()
            .compactMap { [weak self] shutterSpeeds in
                guard let shutterSpeed = self?.shutterSpeed else { return nil }
                return shutterSpeeds.nearest(to: shutterSpeed)
            }
            .assign(to: &$shutterSpeed)
        
        $isoValues
            .removeDuplicates()
            .compactMap { [weak self] isoValues in
                guard let iso = self?.iso else { return nil }
                return isoValues.nearest(to: iso)
            }
            .assign(to: &$iso)
        
        $preferedFocalLengths.removeDuplicates().combineLatest(camera.minZoomFactor, camera.maxZoomFactor)
            .map { [weak self] focalLengths, minZoomFactor, maxZoomFactor -> [FocalLengthValue] in
                guard let self else { return [] }
                let filtered = focalLengths
                    .filter { $0.zoomFactor >= minZoomFactor }
                    .filter { $0.zoomFactor <= maxZoomFactor }
                return filtered.isEmpty
                    ? [FocalLengthValue(fallbackFocalLength)].compactMap { $0 }
                    : filtered
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$focalLengths)
        
        $focalLengths
            .removeDuplicates()
            .compactMap { [weak self] focalLengths in
                guard let value = self?.focalLength.value else { return nil }
                return focalLengths.first { Float($0.value) == Float(value).nearest(among: focalLengths.map { Float($0.value) }) }
            }
            .assign(to: &$focalLength)
        
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
            .filter { [weak self] _ in
                self?.lightMeterMode == .aperture && self?.isCapturing == false
            }
            .compactMap { [weak self] ev, iso, shutterSpeed in
                guard let self,
                      let apertureValue = try? LightMeterService.getApertureValue(ev: ev, iso: Float(iso.value), shutterSpeed: shutterSpeed.value) else { return nil }
                return apertures.nearest(to: apertureValue)
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$aperture)
        
        $isCameraRunning.combineLatest($exposureValue, $iso, $aperture)
            .removeDuplicates { $0 == $1 }
            .filter { $0.0 }
            .map { ($0.1, $0.2, $0.3) }
            .filter { [weak self] _ in
                self?.lightMeterMode == .shutterSpeed && self?.isCapturing == false
            }
            .compactMap { [weak self] ev, iso, aperture in
                guard let self,
                      let shutterSpeedValue = try? LightMeterService.getShutterSpeedValue(ev: ev, iso: Float(iso.value), aperture: aperture.value) else { return nil }
                return shutterSpeeds.nearest(to: shutterSpeedValue)
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$shutterSpeed)
        
        $isCameraRunning.combineLatest($exposureValue, $shutterSpeed, $aperture)
            .removeDuplicates { $0 == $1 }
            .filter { $0.0 }
            .map { ($0.1, $0.2, $0.3) }
            .filter { [weak self] _ in
                self?.lightMeterMode == .iso && self?.isCapturing == false
            }
            .compactMap { [weak self] ev, shutterSpeed, aperture in
                guard let self,
                      let isoValue = try? LightMeterService.getIsoValue(ev: ev, shutterSpeed: shutterSpeed.value, aperture: aperture.value) else { return nil }
                return isoValues.nearest(to: isoValue)
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$iso)
        
        $isCameraRunning.combineLatest($focalLength)
            .removeDuplicates { $0 == $1 }
            .filter { $0.0 }
            .sink { [weak self] _, focalLength in
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
        
        camera.exposureValue.combineLatest(camera.exposureOffset)
            .map { $0 + $1 }
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
        
        $apertures
            .map { $0.count == 1 }
            .assign(to: &$isApertureFixed)
        
        $apertures
            .filter { $0.count == 1 }
            .compactMap { $0.first }
            .assign(to: &$aperture)
        
        $shutterSpeeds
            .map { $0.count == 1 }
            .assign(to: &$isShutterSpeedFixed)
        
        $isoValues
            .map { $0.count == 1 }
            .assign(to: &$isIsoFixed)
        
        $focalLengths
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
        
        $exposureCompensation
            .removeDuplicates()
            .sink { [weak self] bias in
                Task { try? await self?.camera.setExposure(bias: bias) }
            }
            .store(in: &cancellables)
        
        $exposureCompensation.combineLatest($isExposureCompensationRingVisible.filter { $0 })
            .debounce(for: .seconds(3), scheduler: debounceQueue)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isExposureCompensationRingVisible = false
            }
            .store(in: &cancellables)
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
                await camera.setMute(!preferenceProvider.shutterSound)
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
            lockPoint = nil
            feedbackProvider.generateInteractionFeedback()
        }
    }
    
    public func didTapExposureCompensationButton() {
        isExposureCompensationRingVisible.toggle()
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
    
    public func willPresentLogger() {
        feedbackProvider.generateInteractionFeedback()
        Task {
            await camera.stop()
        }
    }
    
    public func willDismissLogger() {
        feedbackProvider.generateInteractionFeedback()
        Task {
            await camera.start()
            try? AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
        }
    }
    
    public func willPresentConfig() {
        feedbackProvider.generateInteractionFeedback()
        Task {
            await camera.stop()
            shouldShowConfigOnboarding = false
            statePersistence.shouldShowConfigOnboarding = false
        }
    }
    
    public func willDismissConfig() {
        reloadPreferences()
        feedbackProvider.generateInteractionFeedback()
        Task {
            await camera.start()
            await camera.setMute(!preferenceProvider.shutterSound)
            try? AVAudioSession.sharedInstance().setAllowHapticsAndSystemSoundsDuringRecording(true)
        }
    }
    
    private func reloadPreferences() {
        apertures = preferenceProvider.apertures
        shutterSpeeds = preferenceProvider.shutterSpeeds
        isoValues = preferenceProvider.isoValues
        preferedFocalLengths = preferenceProvider.focalLengths
        apertureRingFeedbackStyle = preferenceProvider.apertureRingFeedbackStyle
        shutterSpeedDialFeedbackStyle = preferenceProvider.shutterSpeedDialFeedbackStyle
        isoDialFeedbackStyle = preferenceProvider.isoDialFeedbackStyle
        focalRingFeedbackStyle = preferenceProvider.focalLengthRingFeedbackStyle
        filmCanister = preferenceProvider.filmCanister
    }
}

extension PortolanCoordinate {
    var coordinate: Coordinate? {
        .init(latitude: latitude, longitude: longitude)
    }
}
