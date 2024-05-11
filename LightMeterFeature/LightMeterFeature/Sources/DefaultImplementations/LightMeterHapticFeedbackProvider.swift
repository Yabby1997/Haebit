import UIKit

public final class LightMeterHapticFeedbackProvider: LightMeterFeedbackProvidable {
    private let interactionFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let completionFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    public init() {}
    
    public func generateInteractionFeedback() {
        interactionFeedbackGenerator.prepare()
        interactionFeedbackGenerator.impactOccurred()
    }
    
    public func generateCompletionFeedback() {
        completionFeedbackGenerator.prepare()
        completionFeedbackGenerator.impactOccurred()
    }
}
