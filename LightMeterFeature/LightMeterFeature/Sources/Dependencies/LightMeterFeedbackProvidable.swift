//
//  LightMeterFeedbackProvidable.swift
//  Haebit
//
//  Created by Seunghun on 12/9/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation

@MainActor
public protocol LightMeterFeedbackProvidable {
    func generateInteractionFeedback()
    func generateCompletionFeedback()
}
