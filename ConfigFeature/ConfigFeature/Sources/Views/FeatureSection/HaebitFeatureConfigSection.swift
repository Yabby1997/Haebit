//
//  HaebitFeatureConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 6/4/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitFeatureConfigSection: View {
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool

    var body: some View {
        Section {
            ConfigToggle(title: .featureSectionRotationTitle, isNew: $viewModel.isRotationNew, isOn: $viewModel.rotation)
        } header: {
            HStack {
                Image.fn
                Text(.featureSectionTitle)
            }
            .font(.system(size: 14, weight: .bold))
        }
        .id(ConfigSection.appearance)
        .foregroundStyle(viewModel.highlightedSection == .appearance ? .yellow : .white)
        .animation(.easeInOut, value: viewModel.highlightedSection)
    }
}
