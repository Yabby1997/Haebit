//
//  HaebitFeedbackConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitFeedbackConfigSection: View {
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        Section {
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.apertureRingFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle(Text(.feedbackSectionApertureRingTitle))
            } label: {
                ConfigLabel(title: .feedbackSectionApertureRingTitle, value: viewModel.apertureRingFeedbackStyle.description)
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.shutterSpeedDialFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle(Text(.feedbackSectionShutterSpeedDialTitle))
            } label: {
                ConfigLabel(title: .feedbackSectionShutterSpeedDialTitle, value: viewModel.shutterSpeedDialFeedbackStyle.description)
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.isoDialFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle(Text(.feedbackSectionIsoDialTitle))
            } label: {
                ConfigLabel(title: .feedbackSectionIsoDialTitle, value: viewModel.isoDialFeedbackStyle.description)
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.exposureCompensationDialFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle(Text(.feedbackSectionExposureCompensationDialTitle))
                    .onAppear { viewModel.isExposureCompensationNew = false }
            } label: {
                ConfigLabel(title: .feedbackSectionExposureCompensationDialTitle, value: viewModel.exposureCompensationDialFeedbackStyle.description, isNew: viewModel.isExposureCompensationNew)
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.focalLengthRingFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle(Text(.feedbackSectionFocalLengthRingTitle))
            } label: {
                ConfigLabel(title: .feedbackSectionFocalLengthRingTitle, value: viewModel.focalLengthRingFeedbackStyle.description)
            }
        } header: {
            HStack {
                Image.handDraw
                Text(.feedbackSectionTitle)
            }
            .font(.system(size: 14, weight: .bold))
        }
        .id(ConfigSection.feedback)
        .foregroundStyle(viewModel.highlightedSection == .feedback ? .yellow : .white)
        .animation(.easeInOut, value: viewModel.highlightedSection)
    }
}
