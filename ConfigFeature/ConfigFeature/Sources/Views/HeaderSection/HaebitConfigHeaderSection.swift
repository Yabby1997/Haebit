//
//  HaebitConfigHeaderSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitConfigHeaderSection: View {
    @StateObject var viewModel: HaebitConfigViewModel
    
    var body: some View {
        Section {} header: {
            ZStack {
                VStack(spacing: 8) {
                    Spacer()
                    HStack {
                        Text(viewModel.currentHeaderType.title)
                            .font(.system(size: 40, weight: .bold, design: .serif))
                        Spacer()
                    }
                    HStack {
                        Text(viewModel.currentHeaderType.description)
                            .font(.system(size: 16, weight: .semibold, design: .serif))
                        Spacer()
                    }
                }
                .animation(.easeInOut(duration: 1), value: viewModel.currentHeaderType)
            }
            .contentShape(Rectangle())
            .listRowInsets(.init(top: .zero, leading: 8, bottom: .zero, trailing: 8))
            .frame(height: 250)
            .onTapGesture(perform: handleTapGesture)
        }
    }
    
    func handleTapGesture() {
        switch viewModel.currentHeaderType {
            
        case .reviewRequest: viewModel.didTapReview()
        case .appearanceSection: viewModel.highlightedSection = .appearance
        case .controlSection: viewModel.highlightedSection = .control
        case .feedbackSection: viewModel.highlightedSection = .feedback
        case .soundSection: viewModel.highlightedSection = .sound
        }
    }
}

extension HeaderType {
    @MainActor
    var title: LocalizedStringResource {
        switch self {
        case .reviewRequest: 
            return .headerReviewRequestTitle
        case .controlSection:
            return .headerControlSectionTitle
        case .feedbackSection:
            return .headerFeedbackSectionTitle
        case .soundSection:
            return .headerSoundSectionTitle
        case .appearanceSection:
            return .headerAppearanceSectionTitle
        }
    }
    
    @MainActor
    var description: LocalizedStringResource {
        switch self {
        case .reviewRequest:
            return .headerReviewRequestDescription
        case .controlSection:
            return .headerControlSectionDescription
        case .feedbackSection:
            return .headerFeedbackSectionDescription
        case .soundSection:
            return .headerSoundSectionDescription
        case .appearanceSection:
            return .headerAppearanceSectionDescription
        }
    }
}
