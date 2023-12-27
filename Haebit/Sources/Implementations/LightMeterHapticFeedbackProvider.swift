//
//  LightMeterHapticFeedbackProvider.swift
//  Haebit
//
//  Created by Seunghun on 12/27/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import UIKit

final class LightMeterHapticFeedbackProvider: LightMeterFeedbackProvidable {
    private let interactionFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let completionFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    func generateInteractionFeedback() {
        interactionFeedbackGenerator.prepare()
        interactionFeedbackGenerator.impactOccurred()
    }
    
    func generateCompletionFeedback() {
        completionFeedbackGenerator.prepare()
        completionFeedbackGenerator.impactOccurred()
    }
}
