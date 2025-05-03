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
    
    var body: some View {
        if viewModel.isIsoFixed == false {
            HaebitApertureRing(
                selection: $viewModel.iso,
                entries: $viewModel.isoValues,
                feedbackStyle: .constant(viewModel.isoDialFeedbackStyle.impactGeneratorFeedbackSyle),
                isMute: .constant(false)
            ) { iso in
                IsoEntryView(iso: iso, viewModel: viewModel)
            }
            .frame(height: 30)
            .onTapGesture { viewModel.lightMeterMode = .iso }
            .disabled(viewModel.isoMode)
        }
    }
}

struct IsoEntryView: View {
    let iso: IsoValue
    @StateObject var viewModel: HaebitLightMeterViewModel
    
    var body: some View {
        Text(iso.title)
            .foregroundStyle(
                viewModel.isoMode
                    ? viewModel.iso == iso
                        ? .yellow
                        : .gray
                    : .white
            )
            .animation(.easeInOut(duration: 0.2), value: viewModel.iso == iso)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isoMode)
            .font(.system(size: 14, weight: .bold, design: .serif))
            .minimumScaleFactor(0.7)
            .lineLimit(1)
            .fixedSize(horizontal: false, vertical: true)
            .shadow(radius: 2)
    }
}
