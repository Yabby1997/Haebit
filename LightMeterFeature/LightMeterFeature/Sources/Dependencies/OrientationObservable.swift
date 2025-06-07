//
//  OrientationObservable.swift
//  LightMeterFeature
//
//  Created by Seunghun on 6/7/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import Combine
import Foundation

@MainActor
public protocol OrientationObservable: AnyObject {
    var orientation: AnyPublisher<Orientation, Never> { get }
}
