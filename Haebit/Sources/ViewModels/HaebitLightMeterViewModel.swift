//
//  HaebitLightMeterViewModel.swift
//  Haebit
//
//  Created by Seunghun on 11/29/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation
import LightMeter
import Obscura
import QuartzCore

final class HaebitLightMeterViewModel: ObservableObject {
    private let camera = ObscuraCamera()
    private let lightMeter = LightMeterService()
    
    var previewLayer: CALayer { camera.previewLayer }
    
    @Published var shouldRequestCameraAccess = false
    
    func setupIfNeeded() {
        Task {
            do {
                try await camera.setup()
            } catch {
                Task { @MainActor in
                    shouldRequestCameraAccess = true
                }
            }
        }
    }
}
