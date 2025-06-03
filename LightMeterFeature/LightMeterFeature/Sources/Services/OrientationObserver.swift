//
//  OrientationObserver.swift
//  LightMeterFeature
//
//  Created by Seunghun on 6/3/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

@preconcurrency import Combine
import Foundation

@MainActor
final class OrientationObserver {
    var orientation: AnyPublisher<Orientation, Never>
    private var orientationSubject: CurrentValueSubject<Orientation?, Never> = .init(nil)
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        orientation = orientationSubject.compactMap { $0 }.eraseToAnyPublisher()
        setup()
    }
    
    private func setup() {
        MotionManager.shared.motionPublisher
            .map { motion -> Orientation in
                if (-45..<45) ~= motion.rotation {
                    return .portrait
                } else if (45..<135) ~= motion.rotation {
                    return .landscapeRight
                } else if (-135 ..< -45) ~= motion.rotation {
                    return .landscapeLeft
                } else {
                    return .portrait
                }
            }
            .assign(to: \.value, on: orientationSubject)
            .store(in: &cancellables)
    }
}
