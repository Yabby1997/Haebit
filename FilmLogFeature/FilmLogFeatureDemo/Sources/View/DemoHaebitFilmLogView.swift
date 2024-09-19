//
//  DemoHaebitFilmLogView.swift
//  FilmLogFeatureDemo
//
//  Created by Seunghun on 5/12/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import FilmLogFeature
import HaebitLogger
import SwiftUI

struct DemoHaebitFilmLogView: View {
    private var logger = HaebitLogger(repository: DefaultHaebitLogRepository())
    @State var isPresentingRegisterView = false
    @State var isPresentingLogView = false
    
    var body: some View {
        VStack(spacing: 12) {
            Button {
                isPresentingRegisterView = true
            } label: {
                Text("Register New Logs")
            }
            Button {
                isPresentingLogView = true
            } label: {
                Text("Open HaebitFilmLogView")
            }
        }
        .fullScreenCover(isPresented: $isPresentingRegisterView) {
            DemoLogRegisterView(
                viewModel: DemoLogRegisterViewModel(logger: logger),
                isPresented: $isPresentingRegisterView
            )
        }
        .fullScreenCover(isPresented: $isPresentingLogView) {
            HaebitFilmLogView(
                logger: logger,
                preferenceProvider: DemoLoggerPreferenceProvider()
            )
        }
    }
}
