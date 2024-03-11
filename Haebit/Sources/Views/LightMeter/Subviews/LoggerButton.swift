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
                Image(asset: .init(name: "filmMagazine"))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            .disabled(viewModel.isCapturing)
        }
        .padding(.horizontal, 20)
    }
}
