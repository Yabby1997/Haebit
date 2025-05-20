//
//  HaebitPreviewTypeSelectionView.swift
//  ConfigFeature
//
//  Created by Seunghun on 5/21/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitPreviewTypeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool

    var body: some View {
        List {
            Section {
                GridSelectionView(
                    entries: PreviewType.allCases,
                    columnCount: 2,
                    selection: $viewModel.previewType
                ) { type in
                    VStack(spacing: 8) {
                        type.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(type.description)
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .bold))
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
            } footer: {
                BulletedList(
                    listItems: [
                        .appearanceSectionPreviewDescription,
                        .appearanceSectionPreviewDescription2,
                    ]
                )
                .listRowInsets(.init(top: 8, leading: .zero, bottom: 8, trailing: .zero))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(.appearanceSectionPreviewTitle))
        .scrollIndicators(.hidden)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresented = false
                } label: {
                    Image.xmark
                        .foregroundStyle(.white)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image.arrowBackward
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

extension PreviewType {
    var image: Image {
        switch self {
        case .fullScreen:
            Image(uiImage: ConfigFeatureAsset.fullScreen.image)
        case .fullCoverage:
            Image(uiImage: ConfigFeatureAsset.fullCoverage.image)
        }
    }
}
