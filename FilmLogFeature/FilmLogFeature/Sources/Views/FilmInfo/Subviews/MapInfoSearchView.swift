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
            ZStack {
                if viewModel.searchResults.isEmpty {
                    VStack {
                        Spacer()
                        Text(.mapInfoSearchViewNoResults)
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                    }
                } else {
                    ScrollView {
                        Color.clear
                            .frame(height: 12)
                            .listRowInsets(.init(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        ForEach(viewModel.searchResults, id:\.self) { result in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(result.name)
                                        .font(.system(size: 14, weight: .bold))
                                    Text(result.address)
                                        .font(.system(size: 12))
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 1)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                viewModel.searchResultSelection = result
                                dismiss()
                            }
                        }
                        Color.clear
                            .frame(height: 40)
                            .listRowInsets(.init(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .scrollIndicators(.hidden)
                    .mask(alignment: .topLeading)  {
                        LinearGradient(colors: [.black, .black.opacity(.zero)], startPoint: .init(x: .zero, y: 0.7), endPoint: .init(x: .zero, y: 1.0))
                    }
                }
            }
            .transition(.slide)
            .animation(.easeInOut(duration: 0.3), value: viewModel.searchResults)
            TextField(text: $viewModel.searchQuery) {
                Text(.mapInfoSearchViewQueryPlaceholder)
            }
//            TextField(.mapInfoSearchViewQueryPlaceholder, text: $viewModel.searchQuery)
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold, design: .serif))
                .autocorrectionDisabled()
                .foregroundColor(.white)
                .focused($isFocused)
                .onAppear { isFocused = true }
        }
        .padding(.horizontal, 12)
        .padding(.bottom, 20)
        .scrollDismissesKeyboard(.never)
    }
}
