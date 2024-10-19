//
//  HaebitConfigView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/23/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

public struct HaebitConfigView: View {
    @StateObject private var viewModel: HaebitConfigViewModel
    @Binding private var isPresented: Bool
    
    public init(
        configRepository: any HaebitConfigRepository,
        appStoreOpener: any AppStoreOpener,
        appVersionProvider: any AppVersionProvidable,
        mailService: any MailService = DefaultMailService(),
        feedbackGenerator: any HaebitConfigFeedbackGeneratable = DefaultHaebitConfigFeedbackGenerator(),
        isPresented: Binding<Bool>
    ) {
        self._viewModel = StateObject(
            wrappedValue: HaebitConfigViewModel(
                configRepository: configRepository,
                appStoreOpener: appStoreOpener,
                appVersionProvider: appVersionProvider,
                mailService: mailService,
                feedbackGenerator: feedbackGenerator,
                systemInfoProvider: SystemInfoProvider()
            )
        )
        self._isPresented = isPresented
    }
    
    public var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                List {
                    HaebitConfigHeaderSection(viewModel: viewModel)
                    HaebitControlConfigSection(viewModel: viewModel, isPresented: $isPresented)
                    HaebitFeedbackConfigSection(viewModel: viewModel, isPresented: $isPresented)
                    HaebitSoundConfigSection(viewModel: viewModel)
                    HaebitAppearanceConfigSection(viewModel: viewModel, isPresented: $isPresented)
                    HaebitOtherConfigSection(viewModel: viewModel)
                }
                .onChange(of: viewModel.highlightedSection) { section in
                    guard let section else { return }
                    withAnimation {
                        proxy.scrollTo(section, anchor: .center)
                    }
                }
            }
            .onAppear(perform: viewModel.onAppear)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .ignoresSafeArea(.container, edges: .top)
            .scrollIndicators(.hidden)
            .headerProminence(.increased)
            .toolbar {
                ToolbarItem {
                    Button {
                        isPresented = false
                    } label: {
                        Image.xmark
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}
