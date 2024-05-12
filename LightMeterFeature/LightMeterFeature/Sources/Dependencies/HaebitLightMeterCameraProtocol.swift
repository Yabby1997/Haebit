//
//  HaebitLightMeterCameraProtocol.swift
//  LightMeterFeature
//
//  Created by Seunghun on 5/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import QuartzCore

public enum HaebitLightMeterCameraError: Error {
    case notAuthorized
}

public protocol HaebitLightMeterCameraProtocol: Actor {
    nonisolated var previewLayer: CALayer { get }
    var isRunning: AnyPublisher<Bool, Never> { get }
    var maxZoomFactor: AnyPublisher<CGFloat, Never> { get }
    var iso: AnyPublisher<Float, Never> { get }
    var shutterSpeed: AnyPublisher<Float, Never> { get }
    var aperture: AnyPublisher<Float, Never> { get }
    var lockPoint: AnyPublisher<CGPoint?, Never> { get }
    var isLocked: AnyPublisher<Bool, Never> { get }
    
    func setup() async throws
    func zoom(factor: CGFloat) async throws
    func lock(on point: CGPoint) async throws
    func unlock() async throws
    func capture() async throws -> String?
    func start() async
    func stop() async
}
