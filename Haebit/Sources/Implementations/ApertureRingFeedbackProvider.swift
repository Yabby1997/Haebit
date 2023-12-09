//
//  ApertureRingFeedbackProvider.swift
//  Haebit
//
//  Created by Seunghun on 12/5/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import HaebitUI
import UIKit
import AVFAudio

final class ApertureRingFeedbackProvider: HaebitApertureRingFeedbackProvidable {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    func generateClickingFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        AudioServicesPlaySystemSound(1157)
    }
}
