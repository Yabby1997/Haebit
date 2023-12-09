//
//  HaebitLightMeterFeedbackProvidable.swift
//  Haebit
//
//  Created by Seunghun on 12/9/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import UIKit

protocol HaebitLightMeterFeedbackProvidable {
    func generateInteractionFeedback()
    func generateCompletionFeedback()
}

final class DefaultLightMeterFeedbackProvider: HaebitLightMeterFeedbackProvidable {
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
