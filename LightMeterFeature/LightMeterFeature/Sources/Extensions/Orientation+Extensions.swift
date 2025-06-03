//
//  Orientation+Extensions.swift
//  LightMeterFeature
//
//  Created by Seunghun on 6/3/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import Foundation
import SwiftUICore

extension Orientation {
    var angle: Angle {
        switch self {
        case .portrait: return .degrees(.zero)
        case .landscapeLeft: return .degrees(-90)
        case .landscapeRight: return .degrees(90)
        }
    }
}
