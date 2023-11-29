//
//  HaebitLightMeterView.swift
//  Haebit
//
//  Created by Seunghun on 11/29/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

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
                    ValueSlider(
                        title: "ISO",
                        subtitle: "\(Int(viewModel.iso))",
                        valueRange: 50...3200,
                        value: $viewModel.iso
                    )
                    Toggle(isOn: $viewModel.isIsoMode) {}
                        .labelsHidden()
                }
                .disabled(viewModel.isIsoMode)
                HStack {
                    ValueSlider(
                        title: "Shutter",
                        subtitle: String(format: "%.4fs", viewModel.shutterSpeed),
                        valueRange: 0.0005...1,
                        value: $viewModel.shutterSpeed
                    )
                    Toggle(isOn: $viewModel.isShutterSpeedMode) {}
                        .labelsHidden()
                }
                .disabled(viewModel.isShutterSpeedMode)
                HStack {
                    ValueSlider(
                        title: "Aperture",
                        subtitle: String(format: "ƒ%.1f", viewModel.aperture),
                        valueRange: 1.4...22,
                        value: $viewModel.aperture
                    )
                    Toggle(isOn: $viewModel.isApertureMode) {}
                        .labelsHidden()
                }
                .disabled(viewModel.isApertureMode)
            }
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
}
