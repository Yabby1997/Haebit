//
//  FeedbackStyle.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/29/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Foundation

enum FeedbackStyle: CaseIterable, Identifiable {
    case heavy
    case medium
    case light
    case rigid
    case soft
    
    var id: String { description }
    
    var description: String {
        switch self {
        case .heavy: return "Heavy"
        case .medium: return "Medium"
        case .light: return "Light"
        case .rigid: return "Rigid"
        case .soft: return "Soft"
        }
    }
}
