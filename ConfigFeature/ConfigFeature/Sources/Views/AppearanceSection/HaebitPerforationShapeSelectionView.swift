//
//  HaebitPerforationShapeSelectionView.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitPerforationShapeSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool

    var body: some View {
        List {
            Section {
                GridSelectionView(
                    entries: PerforationShape.allCases,
                    columnCount: 2,
                    selection: $viewModel.perforationShape
                ) { shape in
                    VStack(spacing: 8) {
                        shape.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(shape.description)
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .bold))
                    }
                }
                .listRowBackground(Color.clear)
                .listRowInsets(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
            } footer: {
                Text(.appearanceSectionPerforationDescription)
                    .listRowInsets(.init(top: 8, leading: .zero, bottom: 8, trailing: .zero))
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(.appearanceSectionPerforationTitle))
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

extension PerforationShape {
    var image: Image {
        switch self {
        case .bh:
            Image(uiImage: ConfigFeatureAsset.frameBH.image)
        case .ks:
            Image(uiImage: ConfigFeatureAsset.frameKS.image)
        }
    }
}
