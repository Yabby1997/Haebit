import HaebitUI
import UIKit
import AVFAudio

public final class ApertureRingZoomFeedbackProvider: HaebitApertureRingFeedbackProvidable {
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    public init() {}
    
    public func generateClickingFeedback() {
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }
}
