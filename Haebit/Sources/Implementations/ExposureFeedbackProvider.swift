//
//  ExposureFeedbackProvider.swift
//  Haebit
//
//  Created by Seunghun on 12/5/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import HaebitUI
import UIKit
import AVFAudio

final class ExposureFeedbackProvider: HaebitApertureRingFeedbackProvidable {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    func generateClickingFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        AudioServicesPlaySystemSound(1157)
    }
}
