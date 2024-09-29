//
//  HaebitAppearanceConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitAppearanceConfigSection: View {
    @StateObject var viewModel: HaebitConfigViewModel

    var body: some View {
        Section {
            NavigationLink {
                Text("Perforation")
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
                    Text("Film Canister")
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
