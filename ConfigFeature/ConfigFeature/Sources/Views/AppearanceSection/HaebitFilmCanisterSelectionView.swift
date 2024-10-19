//
//  HaebitFilmCanisterSelectionView.swift
//  ConfigFeature
//
//  Created by Seunghun on 10/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels

struct HaebitFilmCanisterSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel: HaebitConfigViewModel
    @Binding var isPresented: Bool
    
    var body: some View {
        List {
            Section {
                viewModel.filmCanister.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .animation(.easeInOut, value: viewModel.filmCanister)
            } footer: {
                Text(.appearanceSectionFilmCanisterDescription)
                    .listRowInsets(.init(top: 8, leading: .zero, bottom: 8, trailing: .zero))
            }
            .listRowBackground(Color.clear)
            Section {
                GridSelectionView(
                    entries: FilmCanister.allCases,
                    columnCount: 3,
                    selection: $viewModel.filmCanister
                ) { canister in
                    VStack(spacing: 8) {
                        canister.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(canister.description)
                            .foregroundStyle(.white)
                            .font(.system(size: 12, weight: .bold))
                    }
                }
                .listRowInsets(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
                .listRowBackground(Color.clear)
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(Text(.appearanceSectionFilmCanisterTitle))
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

extension FilmCanister {
    var image: Image {
        switch self {
        case .kodakUltramax400:
            return Image(uiImage: ConfigFeatureAsset.kodakUltramax400.image)
        case .kodakColorPlus200:
            return Image(uiImage: ConfigFeatureAsset.kodakColor200.image)
        case .kodakGold200:
            return Image(uiImage: ConfigFeatureAsset.kodakGold200.image)
        case .kodakE100:
            return Image(uiImage: ConfigFeatureAsset.kodakE100.image)
        case .kodakPortra800:
            return Image(uiImage: ConfigFeatureAsset.kodakPortra800.image)
        case .cinestill800T:
            return Image(uiImage: ConfigFeatureAsset.cinestill800T.image)
        case .cinestill400D:
            return Image(uiImage: ConfigFeatureAsset.cinestill400D.image)
        case .cinestill50D:
            return Image(uiImage: ConfigFeatureAsset.cinestill50D.image)
        case .ilfordXP2:
            return Image(uiImage: ConfigFeatureAsset.ilfordxp2super.image)
        case .fujiXtra400:
            return Image(uiImage: ConfigFeatureAsset.fujiFilmXTra400.image)
        }
    }
}
