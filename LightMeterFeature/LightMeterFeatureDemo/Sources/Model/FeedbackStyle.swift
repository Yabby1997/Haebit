//
//  FeedbackStyle.swift
//  LightMeterFeature
//
//  Created by Seunghun on 7/21/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

enum FeedbackStyle: String, CaseIterable, Identifiable {
    case heavy = "Heavy"
    case medium = "Medium"
    case light = "Light"
    case rigid = "Rigid"
    case soft = "Soft"
    
    var id: String { self.rawValue }
}
