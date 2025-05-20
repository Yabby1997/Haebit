//
//  HaebitLightMeterFullCoverageView.swift
//  LightMeterFeature
//
//  Created by Seunghun on 5/20/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitLightMeterFullCoverageView: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    @Binding var isPresentingLogger: Bool
    @Binding var isPresentingConfig: Bool
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    HaebitCameraView(previewLayer: viewModel.previewLayer)
                        .onTapGesture(coordinateSpace: .local, perform: viewModel.didTap(point:))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    guard abs(value.velocity.height) > abs(value.velocity.width),
                                          value.translation.height < -50 else { return }
                                    isPresentingConfig = true
                                }
                        )
                    if viewModel.isFixedDescriptionVisible {
                        LightMeterFixedDescriptionView(description: viewModel.fixedDescription)
                            .padding(4)
                    }
                    LightMeterResultDescriptionView(
                        resultDescription: viewModel.resultDescription,
                        exposureValue: viewModel.exposureValue,
                        isLocked: viewModel.isLocked
                    )
                    if let point = viewModel.lockPoint {
                        LockIindicatorView(point: point, isHighlighted: viewModel.isLocked)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .aspectRatio(2 / 3, contentMode: .fit)
                .padding(.horizontal, 2)
                Spacer()
            }
            LightMeterControlView(viewModel: viewModel, isPresentingLogger: $isPresentingLogger)
        }
    }
}
