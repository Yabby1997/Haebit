//
//  FocalRing.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct FocalRing<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies
    
    var body: some View {
        HaebitApertureRing(selection: $viewModel.focalLength, entries: $viewModel.focalLengthValues) {
            Rectangle()
                .foregroundStyle(.white)
                .frame(width: 2, height: 6)
                .cornerRadius(0.5)
        } content: { focalLength in
            Text(focalLength.title)
                .foregroundStyle(.green)
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .shadow(radius: 2)
        }
        .environmentObject(dependencies.zoomControlDependency)
    }
}
