//
//  IsoRing.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import HaebitCommonModels
import HaebitUI

struct IsoRing: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies
    
    var body: some View {
        HaebitApertureRing(selection: $viewModel.iso, entries: $viewModel.isoValues) { iso in
            Text(iso.title)
                .foregroundStyle(
                    viewModel.isoMode
                        ? viewModel.iso == iso
                            ? .yellow
                            : .gray
                        : .white
                )
                .font(.system(size: 14, weight: .bold, design: .serif))
                .shadow(radius: 2)
        }
        .environmentObject(dependencies.exposureControlDependency)
        .onTapGesture { viewModel.lightMeterMode = .iso }
        .disabled(viewModel.isoMode)
    }
}
