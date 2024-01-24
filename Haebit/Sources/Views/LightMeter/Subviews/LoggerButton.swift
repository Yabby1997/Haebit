//
//  LoggerButton.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct LoggerButton<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                viewModel.didTapLogger()
            } label: {
                Image(systemName: "book.closed.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
            .disabled(viewModel.isCapturing)
            .foregroundStyle(viewModel.isCapturing ? .gray : .yellow)
        }
        .padding(.horizontal, 20)
    }
}
