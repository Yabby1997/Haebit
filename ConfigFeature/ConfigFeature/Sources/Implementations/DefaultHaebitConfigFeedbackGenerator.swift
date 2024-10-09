//
//  DefaultHaebitConfigFeedbackGenerator.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/9/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import HaebitCommonModels
import UIKit

@MainActor
public final class DefaultHaebitConfigFeedbackGenerator: HaebitConfigFeedbackGeneratable {
    private let heavyFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let lightFeedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumFeedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let rigidFeedbackGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let softFeedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    private var feedbackTask: Task<Void, Never>?
    
    public init() {}
    
    public func generate(feedback: FeedbackStyle) {
        switch feedback {
        case .heavy:
            generate(with: heavyFeedbackGenerator)
        case .light:
            generate(with: lightFeedbackGenerator)
        case .medium:
            generate(with: mediumFeedbackGenerator)
        case .rigid:
            generate(with: rigidFeedbackGenerator)
        case .soft:
            generate(with: softFeedbackGenerator)
        }
    }
    
    @MainActor
    private func generate(with generator: UIImpactFeedbackGenerator) {
        feedbackTask?.cancel()
        feedbackTask = Task {
            for _ in 0..<4 {
                try? await Task.sleep(nanoseconds: 100_000_000)
                generator.impactOccurred()
            }
            for i in 1...5 {
                try? await Task.sleep(nanoseconds: 100_000_000 + 20_000_000 * UInt64(i))
                generator.impactOccurred()
            }
        }
    }
}
