//
//  HaebitAppearanceConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitAppearanceConfigSection: View {
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool

    var body: some View {
        Section {
            NavigationLink {
                HaebitPreviewTypeSelectionView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                ConfigLabel(title: .appearanceSectionPreviewTitle, value: viewModel.previewType.description, isNew: viewModel.isPreviewNew)
            }
            NavigationLink {
                HaebitPerforationShapeSelectionView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                ConfigLabel(title: .appearanceSectionPerforationTitle, value: viewModel.perforationShape.description)
            }
            NavigationLink {
                HaebitFilmCanisterSelectionView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                ConfigLabel(title: .appearanceSectionFilmCanisterTitle, value: viewModel.filmCanister.description)
            }
        } header: {
            HStack {
                Image.sparkles
                Text(.appearanceSectionTitle)
            }
            .font(.system(size: 14, weight: .bold))
        }
        .id(ConfigSection.appearance)
        .foregroundStyle(viewModel.highlightedSection == .appearance ? .yellow : .white)
        .animation(.easeInOut, value: viewModel.highlightedSection)
    }
}
