//
//  Orientation.swift
//  LightMeterFeature
//
//  Created by Seunghun on 6/3/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import Foundation

enum Orientation: Equatable {
    case portrait
    case landscapeRight
    case landscapeLeft
    
    var isLandscape: Bool { self == .landscapeLeft || self == .landscapeRight }
}
