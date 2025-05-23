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
                HStack {
                    Text(.appearanceSectionPreviewTitle)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.previewType.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                HaebitPerforationShapeSelectionView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                HStack {
                    Text(.appearanceSectionPerforationTitle)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.perforationShape.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink {
                HaebitFilmCanisterSelectionView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                HStack {
                    Text(.appearanceSectionFilmCanisterTitle)
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.filmCanister.description)
                        .font(.system(size: 14, design: .monospaced))
                }
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
