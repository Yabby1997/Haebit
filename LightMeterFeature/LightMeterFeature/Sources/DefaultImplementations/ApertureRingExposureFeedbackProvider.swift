import HaebitUI
import UIKit
import AVFAudio

public final class ApertureRingExposureFeedbackProvider: HaebitApertureRingFeedbackProvidable {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    public init() {}
    
    public func generateClickingFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        AudioServicesPlaySystemSound(1157)
    }
}
