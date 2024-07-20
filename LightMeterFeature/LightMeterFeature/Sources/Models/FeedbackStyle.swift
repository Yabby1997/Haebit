//
//  FeedbackStyle.swift
//  LightMeterFeature
//
//  Created by Seunghun on 7/20/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

public enum FeedbackStyle {
    case heavy
    case medium
    case light
    case rigid
    case soft
}

extension FeedbackStyle {
    var impactGeneratorFeedbackSyle: UIImpactFeedbackGenerator.FeedbackStyle {
        switch self {
        case .heavy: return .heavy
        case .medium: return .medium
        case .light: return .light
        case .rigid: return .rigid
        case .soft: return .soft
        }
    }
}
