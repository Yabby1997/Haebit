//
//  HaebitConfigView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/23/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI

public struct HaebitConfigView: View {
    @StateObject var viewModel: HaebitConfigViewModel
    
    public init() {
        let viewModel = HaebitConfigViewModel()
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        NavigationStack {
            List {
                HaebitConfigHeaderSection()
                HaebitControlConfigSection(viewModel: viewModel)
                HaebitFeedbackConfigSection(viewModel: viewModel)
                HaebitAppearanceConfigSection(viewModel: viewModel)
                HaebitOtherConfigSection(viewModel: viewModel)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.hidden, for: .navigationBar)
            .ignoresSafeArea(.all)
            .scrollIndicators(.hidden)
            .headerProminence(.increased)
            .toolbar {
                ToolbarItem {
                    Button {
                        print("Close")
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(.white)
                    }
                }
            }
        }
    }
}

#Preview {
    HaebitConfigView()
}
