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
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: viewModel.didTapUnlock) { Text("Unlock") }
                .opacity(viewModel.isLocked ? 1.0 : .zero)
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundStyle(.yellow)
                .shadow(radius: 5)
                .animation(.easeInOut, value: viewModel.isLocked)
            HaebitApertureRing(selection: $viewModel.aperture, entries: viewModel.apertureValues) {
                Circle().foregroundColor(.red)
            } content: { aperture in
                Text(aperture.title)
                    .foregroundStyle(viewModel.apertureMode ? viewModel.aperture == aperture ? .yellow : .gray : .white)
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
            }
            .onTapGesture { viewModel.lightMeterMode = .aperture }
            .disabled(viewModel.apertureMode)
            HaebitApertureRing(selection: $viewModel.shutterSpeed, entries: viewModel.shutterSpeedValues) {
                Circle().foregroundColor(.red)
            } content: { shutterSpeed in
                Text(shutterSpeed.title)
                    .foregroundStyle(viewModel.shutterSpeedMode ? viewModel.shutterSpeed == shutterSpeed ? .yellow : .gray : .white)
                    .font(.system(size: 18, weight: .bold, design: .serif))
            }
            .onTapGesture { viewModel.lightMeterMode = .shutterSpeed }
            .disabled(viewModel.shutterSpeedMode)
            HaebitApertureRing(selection: $viewModel.iso, entries: viewModel.isoValues) {
                Circle().foregroundColor(.red)
            } content: { iso in
                Text(iso.title)
                    .foregroundStyle(viewModel.isoMode ? viewModel.iso == iso ? .yellow : .gray : .white)
                    .font(.system(size: 14, weight: .bold, design: .serif))
            }
            .onTapGesture { viewModel.lightMeterMode = .iso }
            .disabled(viewModel.isoMode)
        }
        .shadow(radius: 10)
        .padding(.vertical, 20)
        .background {
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.8), .clear]),
                startPoint: .bottom,
                endPoint: .init(x: 0.5, y: 0.7)
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    LightMeterControlView(viewModel: DemoHaebitLightMeterViewModel())
            .environmentObject(HaebitApertureRingDependencies(feedbackProvidable: ApertureRingFeedbackProvider()))
}
