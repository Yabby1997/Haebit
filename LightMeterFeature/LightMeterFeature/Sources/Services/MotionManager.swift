//
//  MotionManager.swift
//  LightMeterFeature
//
//  Created by Seunghun on 6/3/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

@preconcurrency import Combine
import CoreMotion
import Foundation

struct Motion: Sendable {
    let roll: Double
    let pitch: Double
    let rotation: Double
}

actor MotionManager {
    static let shared = MotionManager()
    nonisolated let motionPublisher: AnyPublisher<Motion, Never>
    
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    private let motionSubject = PassthroughSubject<Motion, Never>()
    
    private init() {
        motionPublisher = motionSubject.eraseToAnyPublisher()
        motionManager.startDeviceMotionUpdates(to: queue) { [weak self] data, error in
            guard let self, let data else { return }
            handleDeviceMotion(data: data)
        }
    }
    
    nonisolated private func handleDeviceMotion(data: CMDeviceMotion) {
        let motion = Motion(
            roll: (data.attitude.roll * (180.0 / .pi)).normalizedDegrees,
            pitch: (data.attitude.pitch * (180.0 / .pi)).normalizedDegrees,
            rotation: ((atan2(data.gravity.x, data.gravity.y) - .pi) * (180.0 / .pi)).normalizedDegrees
        )
        Task {
            await motionSubject.send(motion)
        }
    }
}

extension Double {
    fileprivate var normalizedDegrees: Double {
        let remainder = truncatingRemainder(dividingBy: 360)
        return remainder > 180 ? remainder - 360 : (remainder < -180 ? remainder + 360 : remainder)
    }
}
