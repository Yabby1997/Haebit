//
//  ApertureEntry.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

public struct ApertureEntry: Hashable, Sendable {
    let value: ApertureValue
    var isActive: Bool
    
    public init(value: ApertureValue, isActive: Bool) {
        self.value = value
        self.isActive = isActive
    }
}
