//
//  MockLightMeterCamera.swift
//  LightMeterFeatureDemo
//
//  Created by Seunghun on 7/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

@preconcurrency import Combine
import Foundation
import LightMeter
import LightMeterFeature
@preconcurrency import QuartzCore

actor MockLightMeterCamera: LightMeterCamera {
    private let screenScaleFactor: CGFloat
    nonisolated let previewLayer: CALayer
    
    nonisolated let previewImageSubject = CurrentValueSubject<CGImage?, Never>(nil)
    nonisolated let isRunningSubject = CurrentValueSubject<Bool, Never>(false)
    nonisolated let apertureSubject = CurrentValueSubject<Float, Never>(1.6)
    nonisolated let shutterSpeedSubject = CurrentValueSubject<Float, Never>(1 / 60)
    nonisolated let isoSubject = CurrentValueSubject<Float, Never>(100)
    nonisolated let lockPointSubject = CurrentValueSubject<CGPoint?, Never>(nil)
    nonisolated let isLockedSubject = CurrentValueSubject<Bool, Never>(false)
    private let exposureValueSubject = CurrentValueSubject<Float, Never>(.zero)
    private let exposureBiasSubject = CurrentValueSubject<Float, Never>(.zero)
    
    nonisolated let maxZoomFactor: AnyPublisher<CGFloat, Never> = Just(.greatestFiniteMagnitude).eraseToAnyPublisher()
    nonisolated let minZoomFactor: AnyPublisher<CGFloat, Never> = Just(.zero).eraseToAnyPublisher()
    nonisolated let isHDREnabled: AnyPublisher<Bool, Never> = Just(false).eraseToAnyPublisher()
    nonisolated let zoomFactor: AnyPublisher<CGFloat, Never> = Just(1.0).eraseToAnyPublisher()
    nonisolated let isCapturing: AnyPublisher<Bool, Never> = Just(false).eraseToAnyPublisher()
    nonisolated let isRunning: AnyPublisher<Bool, Never>
    nonisolated let iso: AnyPublisher<Float, Never>
    nonisolated let shutterSpeed: AnyPublisher<Float, Never>
    nonisolated let aperture: AnyPublisher<Float, Never>
    nonisolated let exposureLockPoint: AnyPublisher<CGPoint?, Never>
    nonisolated let focusLockPoint: AnyPublisher<CGPoint?, Never>
    nonisolated let isExposureLocked: AnyPublisher<Bool, Never>
    nonisolated let isFocusLocked: AnyPublisher<Bool, Never>
    nonisolated let exposureValue: AnyPublisher<Float, Never>
    nonisolated let exposureOffset: AnyPublisher<Float, Never>
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(screenScaleFactor: CGFloat) {
        self.screenScaleFactor = screenScaleFactor
        self.previewLayer = CALayer()
        self.isRunning = isRunningSubject.eraseToAnyPublisher()
        self.iso = isoSubject.eraseToAnyPublisher()
        self.shutterSpeed = shutterSpeedSubject.eraseToAnyPublisher()
        self.aperture = apertureSubject.eraseToAnyPublisher()
        self.exposureLockPoint = lockPointSubject.eraseToAnyPublisher()
        self.focusLockPoint = lockPointSubject.eraseToAnyPublisher()
        self.isExposureLocked = isLockedSubject.eraseToAnyPublisher()
        self.isFocusLocked = isLockedSubject.eraseToAnyPublisher()
        self.exposureValue = exposureValueSubject.eraseToAnyPublisher()
        self.exposureOffset = exposureBiasSubject.eraseToAnyPublisher()
        Task {
            await bind()
            await setCamera(isOn: true)
        }
    }
    
    private func bind() {
        previewImageSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] image in
                guard let self else { return }
                CATransaction.begin()
                previewLayer.contents = image
                previewLayer.contentsGravity = .resizeAspectFill
                previewLayer.contentsScale = screenScaleFactor
                previewLayer.displayIfNeeded()
                CATransaction.commit()
            }
            .store(in: &cancellables)
        
        Publishers.CombineLatest(
            Publishers.CombineLatest3(iso, shutterSpeed, aperture).compactMap { try? LightMeterService.getExposureValue(iso: $0.0, shutterSpeed: $0.1, aperture: $0.2) },
            exposureOffset
        )
        .map { $0 + $1 }
        .assign(to: \.value, on: exposureValueSubject)
        .store(in: &cancellables)
    }
    
    func setCamera(isOn: Bool) {
        Task {
            try? await Task.sleep(nanoseconds: isOn ? 1_000_000_000 : .zero)
            isRunningSubject.send(isOn)
        }
    }
    
    func setExposure(bias: Float) async throws {
        exposureBiasSubject.send(bias)
    }
    
    func setup() async throws {}
    func start() async {}
    func stop() async {}
    func zoom(factor: CGFloat) async throws {}
    func setHDRMode(isEnabled: Bool) async throws {}
    func setMute(_ isMuted: Bool) async {}
    func lockExposure(on point: CGPoint) async throws {}
    func unlockExposure() async throws {}
    func lockFocus(on point: CGPoint) async throws {}
    func unlockFocus() async throws {}
    func capturePhoto() async throws -> String? { nil }
}
