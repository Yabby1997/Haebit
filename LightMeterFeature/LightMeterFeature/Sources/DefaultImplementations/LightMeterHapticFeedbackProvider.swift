import UIKit

final class LightMeterHapticFeedbackProvider: LightMeterFeedbackProvidable {
    private let interactionFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let completionFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    init() {}
    
    func generateInteractionFeedback() {
        interactionFeedbackGenerator.prepare()
        interactionFeedbackGenerator.impactOccurred()
    }
    
    func generateCompletionFeedback() {
        completionFeedbackGenerator.prepare()
        completionFeedbackGenerator.impactOccurred()
    }
}
