//
//  HaebitLightMeterFullScreenView.swift
//  LightMeterFeature
//
//  Created by Seunghun on 5/20/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitLightMeterFullScreenView: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    @Binding var isPresentingLogger: Bool
    @Binding var isPresentingConfig: Bool
    
    var body: some View {
        ZStack {
            HaebitCameraView(previewLayer: viewModel.previewLayer)
                .ignoresSafeArea()
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
            }
            LightMeterResultDescriptionView(
                resultDescription: viewModel.resultDescription,
                exposureValue: viewModel.exposureValue,
                isLocked: viewModel.isLocked
            )
            if let point = viewModel.lockPoint {
                LockIindicatorView(point: point, isHighlighted: viewModel.isLocked)
            }
            LightMeterControlView(viewModel: viewModel, isPresentingLogger: $isPresentingLogger)
        }
    }
}
