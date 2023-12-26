//
//  LightMeterControlView.swift
//  Haebit
//
//  Created by Seunghun on 12/9/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct LightMeterControlView<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @EnvironmentObject private var dependencies: LightMeterControlViewDependencies
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Button(action: viewModel.didTapUnlock) { Text(.lightMeterControlViewUnlockButton) }
                    .opacity(viewModel.isLocked ? 1.0 : .zero)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundStyle(.yellow)
                    .shadow(radius: 5)
                    .animation(.easeInOut, value: viewModel.isLocked)
                HaebitApertureRing(selection: $viewModel.aperture, entries: viewModel.apertureValues) {
                    Circle()
                        .foregroundColor(.red)
                        .frame(width: 5, height: 5)
                } content: { aperture in
                    Text(aperture.title)
                        .foregroundStyle(viewModel.apertureMode ? viewModel.aperture == aperture ? .yellow : .gray : .white)
                        .font(.system(size: 14, weight: .semibold, design: .monospaced))
                        .shadow(radius: 2)
                }
                .environmentObject(dependencies.exposureControlDependency)
                .onTapGesture { viewModel.lightMeterMode = .aperture }
                .disabled(viewModel.apertureMode)
                HaebitApertureRing(selection: $viewModel.shutterSpeed, entries: viewModel.shutterSpeedValues) { shutterSpeed in
                    Text(shutterSpeed.title)
                        .foregroundStyle(viewModel.shutterSpeedMode ? viewModel.shutterSpeed == shutterSpeed ? .yellow : .gray : .white)
                        .font(.system(size: 18, weight: .bold, design: .serif))
                        .shadow(radius: 2)
                }
                .environmentObject(dependencies.exposureControlDependency)
                .onTapGesture { viewModel.lightMeterMode = .shutterSpeed }
                .disabled(viewModel.shutterSpeedMode)
                HaebitApertureRing(selection: $viewModel.iso, entries: viewModel.isoValues) { iso in
                    Text(iso.title)
                        .foregroundStyle(viewModel.isoMode ? viewModel.iso == iso ? .yellow : .gray : .white)
                        .font(.system(size: 14, weight: .bold, design: .serif))
                        .shadow(radius: 2)
                }
                .environmentObject(dependencies.exposureControlDependency)
                .onTapGesture { viewModel.lightMeterMode = .iso }
                .disabled(viewModel.isoMode)
                HaebitApertureRing(selection: $viewModel.focalLength, entries: viewModel.focalLengths) {
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
            .padding(.vertical, 20)
            .background {
                LinearGradient(
                    gradient: Gradient(colors: [.black.opacity(0.8), .clear]),
                    startPoint: .bottom,
                    endPoint: .init(x: 0.5, y: .zero)
                )
                .ignoresSafeArea()
                .allowsHitTesting(true)
            }
        }
    }
}

#Preview {
    LightMeterControlView(viewModel: DemoHaebitLightMeterViewModel())
        .environmentObject(
            LightMeterControlViewDependencies(
                exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ExposureFeedbackProvider()),
                zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ZoomFeedbackProvider())
            )
        )
}
