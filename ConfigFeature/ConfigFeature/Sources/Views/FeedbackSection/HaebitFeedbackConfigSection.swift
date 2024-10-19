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
                    .navigationTitle(.configViewFeedbackSectionApertureRingTitle)
            } label: {
                HStack {
                    Text(.configViewFeedbackSectionApertureRingTitle)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.apertureRingFeedbackStyle.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.shutterSpeedDialFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle(.configViewFeedbackSectionShutterSpeedDialTitle)
            } label: {
                HStack {
                    Text(.configViewFeedbackSectionShutterSpeedDialTitle)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.shutterSpeedDialFeedbackStyle.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.isoDialFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle(.configViewFeedbackSectionIsoDialTitle)
            } label: {
                HStack {
                    Text(.configViewFeedbackSectionIsoDialTitle)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.isoDialFeedbackStyle.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.focalLengthRingFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle(.configViewFeedbackSectionFocalLengthRingTitle)
            } label: {
                HStack {
                    Text(.configViewFeedbackSectionFocalLengthRingTitle)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.focalLengthRingFeedbackStyle.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
        } header: {
            HStack {
                Image.handDraw
                Text(.configViewFeedbackSectionTitle)
            }
            .font(.system(size: 14, weight: .bold))
        }
        .id(ConfigSection.feedback)
        .foregroundStyle(viewModel.highlightedSection == .feedback ? .yellow : .white)
        .animation(.easeInOut, value: viewModel.highlightedSection)
    }
}
