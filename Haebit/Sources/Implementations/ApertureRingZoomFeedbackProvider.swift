//
//  ApertureRingZoomFeedbackProvider.swift
//  Haebit
//
//  Created by Seunghun on 12/26/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import HaebitUI
import UIKit
import AVFAudio

final class ApertureRingZoomFeedbackProvider: HaebitApertureRingFeedbackProvidable {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    func generateClickingFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}
