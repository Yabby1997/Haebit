//
//  HaebitConfigView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/23/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

public struct HaebitConfigView: View {
    @State private var navigationPath = NavigationPath()
    @StateObject private var viewModel: HaebitConfigViewModel
    @Environment(\.dismiss) private var dismiss
    
    public init(appStoreOpener: any AppStoreOpener) {
        let viewModel = HaebitConfigViewModel(appStoreOpener: appStoreOpener)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollViewReader { proxy in
                List {
                    HaebitConfigHeaderSection(navigationPath: $navigationPath, viewModel: viewModel)
                    HaebitControlConfigSection(viewModel: viewModel)
                    HaebitFeedbackConfigSection(viewModel: viewModel)
                    HaebitAppearanceConfigSection(viewModel: viewModel)
                    HaebitOtherConfigSection(viewModel: viewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigatablePages.self, destination: navigate(to:))
            .toolbarBackground(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all)
            .scrollIndicators(.hidden)
            .headerProminence(.increased)
            .toolbar {
                ToolbarItem {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
    
    private func navigate(to page: NavigatablePages) -> some View {
        switch page {
        case .tipJar: return Text("Buy me a film")
        case .filmCanister: return Text("Film Canister")
        }
    }
}
