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
                HaebitPerforationShapeSelectionView(viewModel: viewModel, isPresented: $isPresented)
            } label: {
                HStack {
                    Text("Perforation")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.perforationShape.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
            NavigationLink(value: NavigatablePages.filmCanister) {
                HStack {
                    Text("FilmCanister")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
                    Text(viewModel.filmCanister.description)
                        .font(.system(size: 14, design: .monospaced))
                }
            }
        } header: {
            HStack {
                Image(systemName: "sparkles")
                Text("Appearance")
            }
            .font(.system(size: 14, weight: .bold))
        }
    }
}
