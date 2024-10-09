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
                    .navigationTitle("Aperture Ring")
            } label: {
                HStack {
                    Text("Aperture Ring")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.apertureRingFeedbackStyle.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.shutterSpeedDialFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle("Shutter Speed Dial")
            } label: {
                HStack {
                    Text("Shutter Speed Dial")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.shutterSpeedDialFeedbackStyle.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.isoDialFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle("ISO Dial")
            } label: {
                HStack {
                    Text("ISO Dial")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.isoDialFeedbackStyle.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                HaebitFeedbackSelectionView(selection: $viewModel.focalLengthRingFeedbackStyle, isPresented: $isPresented)
                    .navigationTitle("Focal Length Ring")
            } label: {
                HStack {
                    Text("Focal Length Ring")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.focalLengthRingFeedbackStyle.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
        } header: {
            HStack {
                Image(systemName: "hand.draw")
                Text("Feedback")
            }
            .font(.system(size: 14, weight: .bold))
        }
    }
}
