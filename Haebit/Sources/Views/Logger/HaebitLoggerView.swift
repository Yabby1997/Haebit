//
//  HaebitLoggerView.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitLogger

struct HaebitLoggerView: View {
    @Binding var isPresented: Bool
    @StateObject var viewModel: HaebitLoggerViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.logs, id: \.self) { log in
                        Text(log.memo)
                    }
                }
            }
            .navigationTitle("Logger")
            .toolbar {
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .onAppear(perform: viewModel.onAppear)
    }
}

#Preview {
    HaebitLoggerView(
        isPresented: .constant(true),
        viewModel: HaebitLoggerViewModel(
            logger: HaebitLogger(repository: MockHaebitLogRepository())
        )
    )
}
