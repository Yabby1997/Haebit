//
//  MockLightMeterCamera.swift
//  LightMeterFeatureDemo
//
//  Created by Seunghun on 7/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

@preconcurrency import Combine
import Foundation
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
    
    nonisolated let maxZoomFactor: AnyPublisher<CGFloat, Never> = Just(.greatestFiniteMagnitude).eraseToAnyPublisher()
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
    }
    
    func setCamera(isOn: Bool) {
        Task {
            try? await Task.sleep(nanoseconds: isOn ? 1_000_000_000 : .zero)
            isRunningSubject.send(isOn)
        }
    }
    
    func setup() async throws {}
    func start() async {}
    func stop() async {}
    func zoom(factor: CGFloat) async throws {}
    func setHDRMode(isEnabled: Bool) async throws {}
    func lockExposure(on point: CGPoint) async throws {}
    func unlockExposure() async throws {}
    func lockFocus(on point: CGPoint) async throws {}
    func unlockFocus() async throws {}
    func capturePhoto() async throws -> String? { nil }
}
