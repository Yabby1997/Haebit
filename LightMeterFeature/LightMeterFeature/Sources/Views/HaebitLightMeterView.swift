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

public struct HaebitLightMeterView<LogView: View, ConfigView: View>: View {
    @StateObject var viewModel: HaebitLightMeterViewModel
    @Environment(\.openURL) var openURL
    @Environment(\.scenePhase) var scenePhase
    let logView: LogView
    let configView: ConfigView
    
    public init(
        viewModel: HaebitLightMeterViewModel,
        logView: LogView,
        configView: ConfigView
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.logView = logView
        self.configView = configView
    }
    
    public var body: some View {
        ZStack {
            HaebitCameraView(previewLayer: viewModel.previewLayer)
                .ignoresSafeArea()
                .onTapGesture(coordinateSpace: .local, perform: viewModel.didTap(point:))
            LightMeterConstantView(viewModel: viewModel)
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
        .alert(.lightMeterViewCameraAccessAlertTitle, isPresented: $viewModel.shouldRequestCameraAccess) {
            Button(action: openSettings) { Text(.lightMeterViewAccessAlertOpenSettingsButton) }
        } message :{ Text(.lightMeterViewCameraAccessAlertMessage) }
        .alert(.lightMeterViewGPSAccessAlertTitle, isPresented: $viewModel.shouldRequestGPSAccess) {
            Button(action: openSettings) { Text(.lightMeterViewAccessAlertOpenSettingsButton) }
            Button(action: viewModel.didTapDoNotAskGPSAccess) { Text(.lightMeterViewAccessAlertDoNotAskButton) }
        } message :{ Text(.lightMeterViewGPSAccessAlertMessage) }
        .fullScreenCover(isPresented: $viewModel.isPresentingLogger, onDismiss: viewModel.didCloseLogger) {
            logView
        }
        .fullScreenCover(isPresented: $viewModel.isPresentingConfig, onDismiss: viewModel.didCloseConfig) {
            configView
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
