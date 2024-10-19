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
    var title: LocalizedStringKey {
        switch self {
        case .reviewRequest: 
            return .configViewHeaderReviewRequestTitle
        case .controlSection:
            return .configViewHeaderControlSectionTitle
        case .feedbackSection:
            return .configViewHeaderFeedbackSectionTitle
        case .soundSection:
            return .configViewHeaderSoundSectionTitle
        case .appearanceSection:
            return .configViewHeaderAppearanceSectionTitle
        }
    }
    
    @MainActor
    var description: LocalizedStringKey {
        switch self {
        case .reviewRequest:
            return .configViewHeaderReviewRequestDescription
        case .controlSection:
            return .configViewHeaderControlSectionDescription
        case .feedbackSection:
            return .configViewHeaderFeedbackSectionDescription
        case .soundSection:
            return .configViewHeaderSoundSectionDescription
        case .appearanceSection:
            return .configViewHeaderAppearanceSectionDescription
        }
    }
}
