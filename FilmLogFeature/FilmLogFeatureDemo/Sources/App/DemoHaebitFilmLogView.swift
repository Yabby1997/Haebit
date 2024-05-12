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
    private var logger: HaebitLogger
    @StateObject var viewModel: HaebitFilmLogViewModel
    @State var isPresentingRegisterView = false
    
    init() {
        let logger = HaebitLogger(repository: DefaultHaebitLogRepository())
        self.logger = logger
        self._viewModel = StateObject(wrappedValue: HaebitFilmLogViewModel(logger: logger))
    }
    
    var body: some View {
        HaebitFilmLogView(viewModel: viewModel)
        .onTapGesture(count: 2) {
            isPresentingRegisterView = true
        }
        .sheet(isPresented: $isPresentingRegisterView) {
            viewModel.onAppear()
        } content: {
            DemoLogRegisterView(
                viewModel: DemoLogRegisterViewModel(
                    logger: logger
                )
            )
        }
    }
}
