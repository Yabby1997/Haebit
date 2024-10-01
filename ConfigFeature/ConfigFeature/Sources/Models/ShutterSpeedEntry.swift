//
//  ShutterSpeedEntry.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

public struct ShutterSpeedEntry: Hashable, Sendable {
    let value: ShutterSpeedValue
    var isActive: Bool
    
    public init(value: ShutterSpeedValue, isActive: Bool = false) {
        self.value = value
        self.isActive = isActive
    }
}
