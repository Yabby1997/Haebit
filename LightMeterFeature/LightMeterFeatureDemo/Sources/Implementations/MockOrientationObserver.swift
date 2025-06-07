//
//  MockOrientationObserver.swift
//  LightMeterFeature
//
//  Created by Seunghun on 6/7/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import Combine
import Foundation
import LightMeterFeature

final class MockOrientationObserver: OrientationObservable {
    @Published var _orientation: Orientation = .portrait
    var orientation: AnyPublisher<Orientation, Never> { $_orientation.eraseToAnyPublisher() }
}
