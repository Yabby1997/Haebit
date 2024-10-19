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
                Text(.othersSectionFeedbackAndInquiryTitle)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Image.arrowUpForward
                    .foregroundStyle(.yellow)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: viewModel.didTapContact)
            HStack {
                Text(.othersSectionReviewOnAppstoreTitle)
                    .font(.system(size: 16, weight: .semibold))
                Spacer()
                Image.arrowUpForward
                    .foregroundStyle(.yellow)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: viewModel.didTapReview)
            HStack {
                Text(.othersSectionVersionTitle)
                    .font(.system(size: 16, weight: .semibold))
                Text(viewModel.appVersion)
                    .font(.system(size: 14, design: .monospaced))
                Spacer()
                Text(
                    viewModel.isLatestVersion
                    ? .othersSectionLatestDescription
                    : .othersSectionUpdateAvailableDescription
                )
                .font(.system(size: 14, design: .monospaced))
                .foregroundStyle(.yellow)
            }
            .contentShape(Rectangle())
            .onTapGesture(perform: viewModel.didTapAppVersion)
        } header: {
            HStack {
                Image.textBubble
                Text(.othersSectionTitle)
            }
            .font(.system(size: 14, weight: .bold))
        }
        .id(ConfigSection.others)
        .foregroundStyle(viewModel.highlightedSection == .others ? .yellow : .white)
        .animation(.easeInOut, value: viewModel.highlightedSection)
    }
}
