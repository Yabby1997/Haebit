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
