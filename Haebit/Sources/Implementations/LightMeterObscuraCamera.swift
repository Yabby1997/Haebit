//
//  LightMeterObscuraCamera.swift
//  LightMeterFeature
//
//  Created by Seunghun on 7/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

@preconcurrency
import Combine
import LightMeterFeature
import Obscura
@preconcurrency
import QuartzCore

fileprivate extension Error {
    var lightMeterCameraError: LightMeterCameraErrors? {
        guard let obscuraError = self as? ObscuraCamera.Errors else {
            return nil
        }
        switch obscuraError {
        case .failedToCapture: return .failedToCapture
        case .notAuthorized: return .notAuthorized
        case .notSupported: return .notSupported
        case .setupRequired: return .setupRequired
        }
    }
}

actor LightMeterObscuraCamera: LightMeterCamera {
    private let camera = ObscuraCamera()
    
    nonisolated public let previewLayer: CALayer
    nonisolated public let isRunning: AnyPublisher<Bool, Never>
    nonisolated public let minZoomFactor: AnyPublisher<CGFloat, Never>
    nonisolated public let maxZoomFactor: AnyPublisher<CGFloat, Never>
    nonisolated public let isHDREnabled: AnyPublisher<Bool, Never>
    nonisolated public let iso: AnyPublisher<Float, Never>
    nonisolated public let shutterSpeed: AnyPublisher<Float, Never>
    nonisolated public let aperture: AnyPublisher<Float, Never>
    nonisolated public let exposureLockPoint: AnyPublisher<CGPoint?, Never>
    nonisolated public let focusLockPoint: AnyPublisher<CGPoint?, Never>
    nonisolated public let isExposureLocked: AnyPublisher<Bool, Never>
    nonisolated public let isFocusLocked: AnyPublisher<Bool, Never>
    nonisolated public let zoomFactor: AnyPublisher<CGFloat, Never>
    nonisolated public let isCapturing: AnyPublisher<Bool, Never>
    nonisolated public let exposureValue: AnyPublisher<Float, Never>
    nonisolated public let exposureOffset: AnyPublisher<Float, Never>

    init() {
        self.previewLayer = camera.previewLayer
        self.isRunning = camera.isRunning
        self.minZoomFactor = camera.minZoomFactor
        self.maxZoomFactor = camera.maxZoomFactor
        self.isHDREnabled = camera.isHDREnabled
        self.iso = camera.iso
        self.shutterSpeed = camera.shutterSpeed
        self.aperture = camera.aperture
        self.exposureLockPoint = camera.exposureLockPoint
        self.focusLockPoint = camera.focusLockPoint
        self.isExposureLocked = camera.isExposureLocked
        self.isFocusLocked = camera.isFocusLocked
        self.zoomFactor = camera.zoomFactor
        self.isCapturing = camera.isCapturing
        self.exposureValue = camera.exposureValue
        self.exposureOffset = camera.exposureOffset
    }
    
    func setup() async throws {
        do {
            try await camera.setup()
        } catch {
            throw error.lightMeterCameraError ?? error
        }
    }
    
    func start() async {
        await camera.start()
    }
    
    func stop() async {
        await camera.stop()
    }
    
    func zoom(factor: CGFloat) async throws {
        do {
            try camera.zoom(factor: factor)
        } catch {
            throw error.lightMeterCameraError ?? error
        }
    }
    
    func setHDRMode(isEnabled: Bool) async throws {
        do {
            try camera.setHDRMode(isEnabled: isEnabled)
        } catch {
            throw error.lightMeterCameraError ?? error
        }
    }
    
    func setMute(_ isMuted: Bool) async {
        camera.setMute(isMuted)
    }
    
    func lockExposure(on point: CGPoint) async throws {
        do {
            try camera.lockExposure(on: point)
        } catch {
            throw error.lightMeterCameraError ?? error
        }
    }
    
    func unlockExposure() async throws {
        do {
            try camera.unlockExposure()
        } catch {
            throw error.lightMeterCameraError ?? error
        }
    }
    
    func lockFocus(on point: CGPoint) async throws {
        do {
            try camera.lockFocus(on: point)
        } catch {
            throw error.lightMeterCameraError ?? error
        }
    }
    
    func unlockFocus() async throws {
        do {
            try camera.unlockFocus()
        } catch {
            throw error.lightMeterCameraError ?? error
        }
    }
    
    func capturePhoto() async throws -> String? {
        do {
            return try await camera.capturePhoto()?.imagePath
        } catch {
            throw error.lightMeterCameraError ?? error
        }
    }
}
