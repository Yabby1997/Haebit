//
//  HaebitOtherConfigSection.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/27/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitOtherConfigSection: View {
    @StateObject var viewModel: HaebitConfigViewModel
    @State var isPresenting: Bool = false
    
    var body: some View {
        Section {
            HStack {
                Text("Feedback & Inquiry")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Image(systemName: "arrow.up.forward")
                    .foregroundStyle(.yellow)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: viewModel.didTapContact)
            HStack {
                Text("Review on AppStore")
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Image(systemName: "arrow.up.forward")
                    .foregroundStyle(.yellow)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: viewModel.didTapReview)
            HStack {
                Text("Version")
                    .font(.system(size: 16, weight: .semibold))
                Text(viewModel.appVersion)
                    .font(.system(size: 14, design: .monospaced))
                Spacer()
                Text(viewModel.isLatestVersion ? "Latest" : "Update Available")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundStyle(.yellow)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: viewModel.didTapAppVersion)
        } header: {
            HStack {
                Image(systemName: "text.bubble")
                Text("Other")
            }
            .font(.system(size: 14, weight: .bold))
        }
        .id(ConfigSection.others)
        .foregroundStyle(viewModel.highlightedSection == .others ? .yellow : .white)
        .animation(.easeInOut, value: viewModel.highlightedSection)
    }
}
