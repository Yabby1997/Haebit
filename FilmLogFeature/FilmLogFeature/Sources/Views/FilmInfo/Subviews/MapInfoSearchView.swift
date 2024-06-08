//
//  MapInfoSearchView.swift
//  FilmLogFeature
//
//  Created by Seunghun on 6/6/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

struct MapInfoSearchView<ViewModel: MapInfoViewModelProtocol>: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var isFocused: Bool
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            if viewModel.searchResults.isEmpty {
                VStack {
                    Spacer()
                    Text("검색 결과가 없습니다.")
                    Spacer()
                }
            } else {
                List(selection: $viewModel.searchResultSelection) {
                    ForEach(viewModel.searchResults, id:\.self) { result in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(result.name)
                                .font(.system(size: 14, weight: .bold))
                            Text(result.address)
                                .font(.system(size: 12))
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
            }
            TextField("Search", text: $viewModel.searchQuery)
                .padding(.horizontal, 12)
                .multilineTextAlignment(.center)
                .font(.system(size: 18, weight: .bold, design: .serif))
                .autocorrectionDisabled()
                .foregroundColor(.white)
                .focused($isFocused)
        }
        .padding(.vertical, 12)
        .preferredColorScheme(.dark)
        .onAppear {
            isFocused = true
        }
    }
}
