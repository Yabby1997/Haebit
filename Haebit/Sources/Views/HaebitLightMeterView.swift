//
//  HaebitLightMeterView.swift
//  Haebit
//
//  Created by Seunghun on 11/29/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct HaebitLightMeterView: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    @Environment(\.openURL) var openURL
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            CameraView(previewLayer: viewModel.previewLayer)
                .ignoresSafeArea()
            Text(String(format: "EV: %.3f", viewModel.exposureValue))
                .font(.largeTitle)
                .foregroundStyle(.white)
                .shadow(radius: 5)
            VStack {
                Spacer()
                HStack {
                    HaebitApertureRing(
                        selection: $viewModel.iso,
                        entries: viewModel.isoValues
                    ) {
                        Circle().foregroundColor(.red)
                    } content: { iso in
                        Text(iso.title)
                            .font(.system(size: 14, weight: .bold, design: .serif))
                    }
                    Toggle(isOn: $viewModel.isIsoMode) {}.labelsHidden()
                }
                .disabled(viewModel.isIsoMode)
                HStack {
                    HaebitApertureRing(
                        selection: $viewModel.shutterSpeed,
                        entries: viewModel.shutterSpeeds
                    ) {
                        Circle().foregroundColor(.red)
                    } content: { shutterSpeed in
                        Text(shutterSpeed.title)
                            .font(.system(size: 18, weight: .bold, design: .serif))
                    }
                    Toggle(isOn: $viewModel.isShutterSpeedMode) {}.labelsHidden()
                }
                .disabled(viewModel.isShutterSpeedMode)
                HStack {
                    HaebitApertureRing(
                        selection: $viewModel.aperture,
                        entries: viewModel.apertureValues
                    ) {
                        Circle().foregroundColor(.red)
                    } content: { aperture in
                        Text(aperture.title)
                            .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    }
                    Toggle(isOn: $viewModel.isApertureMode) {}.labelsHidden()
                }
                .disabled(viewModel.isApertureMode)
            }
            .foregroundStyle(.white)
            .shadow(radius: 5)
            .padding()
        }
        .onChange(of: scenePhase) { phase in
            guard phase == .active else { return }
            viewModel.setupIfNeeded()
        }
        .alert(isPresented: $viewModel.shouldRequestCameraAccess) {
            Alert(
                title: Text("카메라 권한이 필요합니다."),
                primaryButton: .default(Text("설정 열기")) {
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                    openURL(settingsUrl)
                },
                secondaryButton: .destructive(Text("종료")) {
                    fatalError("Can't use Haebit without camera access")
                }
            )
        }
    }
}

#Preview {
    HaebitLightMeterView(viewModel: HaebitLightMeterViewModel())
        .environmentObject(
            HaebitApertureRingDependencies(
                feedbackProvidable: DefaultFeedbackProvidable()
            )
        )
}
