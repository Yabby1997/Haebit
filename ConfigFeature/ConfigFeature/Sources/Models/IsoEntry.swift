//
//  IsoEntry.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/30/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels

public struct IsoEntry: Hashable, Sendable {
    let value: IsoValue
    var isActive: Bool
    
    public init(value: IsoValue, isActive: Bool) {
        self.value = value
        self.isActive = isActive
    }
}
