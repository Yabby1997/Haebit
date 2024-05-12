//
//  HaebitLightMeterDefaultCamera.swift
//  LightMeterFeature
//
//  Created by Seunghun on 5/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

@preconcurrency import Combine
import Foundation
import LightMeter
import Obscura
@preconcurrency import QuartzCore

public actor HaebitLightMeterDefaultCamera: HaebitLightMeterCameraProtocol {
    private let camera = ObscuraCamera()
    
    nonisolated public let previewLayer: CALayer
    public var isRunning: AnyPublisher<Bool, Never> { $_isRunning.eraseToAnyPublisher() }
    public var maxZoomFactor: AnyPublisher<CGFloat, Never> { $_maxZoomFactor.eraseToAnyPublisher() }
    public var exposureValue: AnyPublisher<Float, Never> { $_exposureValue.eraseToAnyPublisher() }
    public var lockPoint: AnyPublisher<CGPoint?, Never> { $_lockPoint.eraseToAnyPublisher() }
    public var isLocked: AnyPublisher<Bool, Never> { $_isLocked.eraseToAnyPublisher() }
    
    @Published private var _isRunning = false
    @Published private var _maxZoomFactor: CGFloat = .infinity
    @Published private var _exposureValue: Float = .zero
    @Published private var _lockPoint: CGPoint?
    @Published private var _isLocked: Bool = false
    
    public init() {
        previewLayer = camera.previewLayer
    }
    
    private func bind() {
        Task {
            await camera.isRunning.assign(to: &$_isRunning)
            await camera.maxZoomFactor.assign(to: &$_maxZoomFactor)
            await camera.focusLockPoint.combineLatest(await camera.exposureLockPoint)
                .filter { $0 == $1 }
                .map { $0.0 }
                .assign(to: &$_lockPoint)
            await camera.isFocusLocked.combineLatest(await camera.isExposureLocked)
                .map { $0 == $1 && $0 }
                .assign(to: &$_isLocked)
            await camera.iso.combineLatest(camera.shutterSpeed, camera.aperture)
                .removeDuplicates { $0 == $1 }
                .compactMap { iso, shutterSpeed, aperture in
                    try? LightMeterService.getExposureValue(
                        iso: iso,
                        shutterSpeed: shutterSpeed,
                        aperture: aperture
                    )
                }
                .assign(to: &$_exposureValue)
        }
    }
    
    public func setup() async throws {
        do {
            try await camera.setup()
        } catch {
            if case .notAuthorized = error as? ObscuraCamera.Errors {
                throw HaebitLightMeterCameraError.notAuthorized
            }
            throw error
        }
        try? await camera.setHDRMode(isEnabled: false)
        bind()
    }
    
    public func zoom(factor: CGFloat) async throws {
        try await camera.zoom(factor: factor)
    }
    
    public func lock(on point: CGPoint) async throws {
        try await camera.lockExposure(on: point)
        try await camera.lockFocus(on: point)
    }
    
    public func unlock() async throws {
        try await camera.unlockExposure()
        try await camera.unlockFocus()
    }
    
    public func capture() async throws -> String? {
        try await camera.capturePhoto()?.imagePath
    }
    
    public func start() async {
        await camera.start()
    }
    
    public func stop() async {
        await camera.stop()
    }
}
