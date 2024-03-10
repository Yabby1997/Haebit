//
//  HaebitLightMeterView.swift
//  Haebit
//
//  Created by Seunghun on 11/29/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI
import HaebitUI
import StoreKit
import HaebitLogger

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
        .onChange(of: scenePhase, perform: didChangeScene)
        .onChange(of: viewModel.shouldRequestReview, perform: requestReview)
        .disabled(viewModel.isCapturing)
        .alert(.lightMeterViewAccessAlertTitle, isPresented: $viewModel.shouldRequestCameraAccess) {
            Button(action: openSettings) { Text(.lightMeterViewAccessAlertOpenSettingsButton) }
        } message :{
            Text(.lightMeterViewAccessAlertMessage)
        }
        .alert("위치 정보 요청", isPresented: $viewModel.shouldRequestGPSAccess) {
            Button(action: openSettings) { Text(.lightMeterViewAccessAlertOpenSettingsButton) }
            Button(action: viewModel.didTapDoNotAskGPSAccess) { Text("다시 묻지 않기") }
        } message :{
            Text("위치정보 로깅을 위해 위치 권한을 허용해주세요")
        }
        .fullScreenCover(isPresented: $viewModel.isPresentingLogger, onDismiss: viewModel.didCloseLogger) {
            HaebitFilmListView(viewModel: viewModel.filmListViewModel())
                .persistentSystemOverlays(.hidden)
                .statusBarHidden()
                .ignoresSafeArea()
        }
    }
    
    private func didChangeScene(phase: ScenePhase) {
        switch phase {
        case .active:
            viewModel.setupIfNeeded()
        case .background, .inactive:
            viewModel.prepareInactive()
        @unknown default:
            return
        }
    }
    
    private func requestReview(_ request: Bool) {
        guard request,
              let scene = (UIApplication.shared.connectedScenes.first { $0.activationState == .foregroundActive }),
              let windowScene = scene as? UIWindowScene else { return }
        SKStoreReviewController.requestReview(in: windowScene)
    }
    
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(settingsUrl)
    }
}

#Preview {
    HaebitLightMeterView(viewModel: DemoHaebitLightMeterViewModel())
        .environmentObject(
            LightMeterControlViewDependencies(
                exposureControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingExposureFeedbackProvider()),
                zoomControlDependency: HaebitApertureRingDependencies(feedbackProvidable: ApertureRingZoomFeedbackProvider()),
                shutterButtonDependency: HaebitShutterButtonDependencies(feedbackProvidable: DefaultShutterButtonFeedbackProvider())
            )
        )
}
