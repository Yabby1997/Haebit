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
            if let point = viewModel.lockPoint {
                LockIindicatorView(point: point, isHighlighted: viewModel.isLocked)
            }
            VStack {
                ZStack {
                    Spacer()
                    LightMeterResultDescriptionView(
                        resultDescription: viewModel.resultDescription,
                        exposureValue: viewModel.exposureValue,
                        isLocked: viewModel.isLocked
                    )
                    .rotationEffect(viewModel.orientation.angle)
                    if viewModel.isFixedDescriptionVisible {
                        VStack {
                            LightMeterFixedDescriptionView(description: viewModel.fixedDescription)
                            Spacer()
                        }
                        .opacity(viewModel.orientation == .portrait ? 1.0 : .zero)
                        HStack {
                            Spacer()
                            LightMeterFixedDescriptionView(description: viewModel.fixedDescription)
                                .rotateClockwise()
                        }
                        .opacity(viewModel.orientation == .landscapeRight ? 1.0 : .zero)
                        HStack {
                            LightMeterFixedDescriptionView(description: viewModel.fixedDescription)
                                .rotateAnticlockwise()
                            Spacer()
                        }
                        .opacity(viewModel.orientation == .landscapeLeft ? 1.0 : .zero)
                    }
                    VStack {
                        Spacer()
                        UnlockButton(viewModel: viewModel)
                    }
                    .opacity(viewModel.orientation == .portrait ? 1.0 : .zero)
                    HStack {
                        UnlockButton(viewModel: viewModel)
                            .rotateClockwise()
                        Spacer()
                    }
                    .opacity(viewModel.orientation == .landscapeRight ? 1.0 : .zero)
                    HStack {
                        Spacer()
                        UnlockButton(viewModel: viewModel)
                            .rotateAnticlockwise()
                    }
                    .opacity(viewModel.orientation == .landscapeLeft ? 1.0 : .zero)
                }
                .padding(.horizontal, 6)
                LightMeterControlView(viewModel: viewModel, isPresentingLogger: $isPresentingLogger)
            }
            .animation(.easeInOut, value: viewModel.orientation)
            .animation(.easeInOut, value: viewModel.isExposureCompensationMode)
        }
    }
}
