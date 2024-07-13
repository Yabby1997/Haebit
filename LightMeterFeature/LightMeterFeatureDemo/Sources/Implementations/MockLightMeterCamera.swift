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
    nonisolated let previewLayer: CALayer
    nonisolated let isRunning: AnyPublisher<Bool, Never>
    nonisolated let maxZoomFactor: AnyPublisher<CGFloat, Never>
    nonisolated let isHDREnabled: AnyPublisher<Bool, Never>
    nonisolated let iso: AnyPublisher<Float, Never>
    nonisolated let shutterSpeed: AnyPublisher<Float, Never>
    nonisolated let aperture: AnyPublisher<Float, Never>
    nonisolated let exposureLockPoint: AnyPublisher<CGPoint?, Never>
    nonisolated let focusLockPoint: AnyPublisher<CGPoint?, Never>
    nonisolated let isExposureLocked: AnyPublisher<Bool, Never>
    nonisolated let isFocusLocked: AnyPublisher<Bool, Never>
    nonisolated let zoomFactor: AnyPublisher<CGFloat, Never>
    nonisolated let isCapturing: AnyPublisher<Bool, Never>
    
    init() {
        self.previewLayer = CALayer()
        self.isRunning = Just(false).eraseToAnyPublisher()
        self.maxZoomFactor = Just(10).eraseToAnyPublisher()
        self.isHDREnabled = Just(false).eraseToAnyPublisher()
        self.iso = Just(100).eraseToAnyPublisher()
        self.shutterSpeed = Just(1.0).eraseToAnyPublisher()
        self.aperture = Just(1.4).eraseToAnyPublisher()
        self.exposureLockPoint = Just(nil).eraseToAnyPublisher()
        self.focusLockPoint = Just(nil).eraseToAnyPublisher()
        self.isExposureLocked = Just(false).eraseToAnyPublisher()
        self.isFocusLocked = Just(false).eraseToAnyPublisher()
        self.zoomFactor = Just(1.0).eraseToAnyPublisher()
        self.isCapturing = Just(false).eraseToAnyPublisher()
    }
    
    func setup() async throws {
        //
    }
    
    func start() async {
        //
    }
    
    func stop() async {
        //
    }
    
    func zoom(factor: CGFloat) async throws {
        //
    }
    
    func setHDRMode(isEnabled: Bool) async throws {
        //
    }
    
    func lockExposure(on point: CGPoint) async throws {
        //
    }
    
    func unlockExposure() async throws {
        //
    }
    
    func lockFocus(on point: CGPoint) async throws {
        //
    }
    
    func unlockFocus() async throws {
        //
    }
    
    func capturePhoto() async throws -> String? {
        nil
    }
}
