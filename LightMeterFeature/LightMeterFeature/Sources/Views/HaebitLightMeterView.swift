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

public struct HaebitLightMeterView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var viewModel: HaebitLightMeterViewModel
    @Binding var isPresentingLogger: Bool
    @Binding var isPresentingConfig: Bool
    
    public init(
        viewModel: HaebitLightMeterViewModel,
        isPresentingLogger: Binding<Bool>,
        isPresentingConfig: Binding<Bool>
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._isPresentingLogger = isPresentingLogger
        self._isPresentingConfig = isPresentingConfig
    }
    
    public var body: some View {
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
            LightMeterControlView(viewModel: viewModel, isPresentingLogger: $isPresentingLogger)
            if let point = viewModel.lockPoint {
                LockIindicatorView(point: point, isHighlighted: viewModel.isLocked)
            }
        }
        .persistentSystemOverlays(.hidden)
        .onChange(of: scenePhase, perform: didChangeScene)
        .onChange(of: viewModel.shouldRequestReview, perform: requestReview)
        .onChange(of: isPresentingLogger, perform: didChange(isPresentingLogger:))
        .onChange(of: isPresentingConfig, perform: didChange(isPresentingConfig:))
        .disabled(viewModel.isCapturing)
        .overlay {
            if viewModel.shouldShowConfigOnboarding {
                ConfigOnboardingView()
            }
        }
        .alert(
            Text(.cameraAccessAlertTitle),
            isPresented: $viewModel.shouldRequestCameraAccess
        ) {
            Button(action: openSettings) {
                Text(.alertOpenSettingsButton)
            }
        } message: {
            Text(.cameraAccessAlertMessage)
        }
        .alert(
            Text(.gpsAccessAlertTitle),
            isPresented: $viewModel.shouldRequestGPSAccess
        ) {
            Button(action: openSettings) {
                Text(.alertOpenSettingsButton)
            }
            Button(action: viewModel.didTapDoNotAskGPSAccess) {
                Text(.gpsAccessDoNotAskAgainButton)
            }
        } message: {
            Text(.gpsAccessAlertMessage)
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
    
    private func didChange(isPresentingLogger: Bool) {
        if isPresentingLogger {
            viewModel.willPresentLogger()
        } else {
            viewModel.willDismissLogger()
        }
    }
    
    private func didChange(isPresentingConfig: Bool) {
        if isPresentingConfig {
            viewModel.willPresentConfig()
        } else {
            viewModel.willDismissConfig()
        }
    }
    
    private func openSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(settingsUrl)
    }
}
