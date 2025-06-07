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
                feedbackStyle: viewModel.isoDialFeedbackStyle.impactGeneratorFeedbackSyle,
                isMute: false
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
            .frame(width: viewModel.orientation.isLandscape ? 30 : 60, height: viewModel.orientation.isLandscape ? 60 : 30)
            .fixedSize(horizontal: false, vertical: true)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .font(.system(size: 14, weight: .bold, design: .serif))
            .rotationEffect(viewModel.orientation.angle)
            .animation(.easeInOut, value: viewModel.orientation)
            .animation(.easeInOut(duration: 0.2), value: viewModel.iso == iso)
            .animation(.easeInOut(duration: 0.2), value: viewModel.isoMode)
            .shadow(radius: 2)
    }
}
