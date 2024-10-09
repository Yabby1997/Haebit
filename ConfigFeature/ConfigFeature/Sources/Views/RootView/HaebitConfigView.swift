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
    @Binding private var isPresented: Bool
    
    public init(
        configRepository: any HaebitConfigRepository,
        appStoreOpener: any AppStoreOpener,
        appVersionProvider: any AppVersionProvidable,
        feedbackGenerator: any HaebitConfigFeedbackGeneratable = DefaultHaebitConfigFeedbackGenerator(),
        isPresented: Binding<Bool>
    ) {
        self._viewModel = StateObject(
            wrappedValue: HaebitConfigViewModel(
                configRepository: configRepository,
                appStoreOpener: appStoreOpener,
                appVersionProvider: appVersionProvider,
                feedbackGenerator: feedbackGenerator
            )
        )
        self._isPresented = isPresented
    }
    
    public var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollViewReader { proxy in
                List {
                    HaebitConfigHeaderSection(navigationPath: $navigationPath, viewModel: viewModel)
                    HaebitControlConfigSection(viewModel: viewModel, isPresented: $isPresented)
                    HaebitFeedbackConfigSection(viewModel: viewModel, isPresented: $isPresented)
                    HaebitAppearanceConfigSection(viewModel: viewModel)
                    HaebitOtherConfigSection(viewModel: viewModel)
                }
            }
            .onAppear(perform: viewModel.onAppear)
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigatablePages.self, destination: navigate(to:))
            .toolbarBackground(.hidden, for: .navigationBar)
            .ignoresSafeArea(.container, edges: .top)
            .scrollIndicators(.hidden)
            .headerProminence(.increased)
            .toolbar {
                ToolbarItem {
                    Button {
                        isPresented = false
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
