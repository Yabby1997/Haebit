//
//  FeedbackStyle+Extensions.swift
//  LightMeterFeature
//
//  Created by Seunghun on 10/2/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import HaebitCommonModels
import UIKit

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
