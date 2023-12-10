//
//  HaebitLightMeterView.swift
//  Haebit
//
//  Created by Seunghun on 11/29/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI

struct HaebitLightMeterView<ViewModel>: View where ViewModel: HaebitLightMeterViewModelProtocol {
    @StateObject var viewModel: ViewModel
    @Environment(\.openURL) var openURL
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        ZStack {
            HaebitCameraView(previewLayer: viewModel.previewLayer)
                .ignoresSafeArea()
                .onTapGesture(coordinateSpace: .local, perform: viewModel.didTap(point:))
            LightMeterResultView(
                resultDescription: viewModel.resultDescription,
                exposureValue: viewModel.exposureValue,
                isLocked: viewModel.isLocked
            )
            LightMeterControlView(viewModel: viewModel)
            if let point = viewModel.lockPoint {
                LockIindicatorView(point: point, isHighlighted: viewModel.isLocked)
            }
        }
        .persistentSystemOverlays(.hidden)
        .onChange(of: scenePhase, perform: didChangeScene(phase:))
        .alert("카메라 권한 요청", isPresented: $viewModel.shouldRequestCameraAccess) {
            Button(action: openSettings) {
                Text("설정 열기")
            }
        } message :{
            Text("노출계 기능 사용을 위해선 카메라 권한이 필요합니다. 설정 앱에서 카메라 권한을 허용해주세요.")
        }
    }
    
    private func didChangeScene(phase: ScenePhase) {
        guard phase == .active else { return }
        viewModel.setupIfNeeded()
    }
    
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(settingsUrl)
    }
}

#Preview {
    HaebitLightMeterView(viewModel: DemoHaebitLightMeterViewModel())
        .environmentObject(HaebitApertureRingDependencies(feedbackProvidable: ApertureRingFeedbackProvider()))
}
