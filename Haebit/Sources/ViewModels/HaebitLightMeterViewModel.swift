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
    @Published private(set) var exposureValue: Float = .zero
    
    @Published var isIsoMode = true {
        didSet {
            guard isIsoMode else { return }
            isShutterSpeedMode = false
            isApertureMode = false
        }
    }
    
    @Published var isShutterSpeedMode = false {
        didSet {
            guard isShutterSpeedMode else { return }
            isIsoMode = false
            isApertureMode = false
        }
    }
    
    @Published var isApertureMode = false {
        didSet {
            guard isApertureMode else { return }
            isIsoMode = false
            isShutterSpeedMode = false
        }
    }
    
    @Published var iso: Float = 200
    @Published var shutterSpeed: Float = 1 / 60
    @Published var aperture: Float = 11
    
    init() {
        bind()
    }
    
    private func bind() {
        camera.iso.combineLatest(camera.shutterSpeed, camera.aperture)
            .compactMap { [weak self] iso, shutterSpeed, aperture in
                try? self?.lightMeter.getExposureValue(
                    iso: iso,
                    shutterSpeed: shutterSpeed,
                    aperture: aperture
                )
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$exposureValue)
        
        $exposureValue.combineLatest($shutterSpeed, $aperture)
            .filter { [weak self] _ in
                self?.isIsoMode == true
            }
            .compactMap { [weak self] ev, shutterSpeed, aperture in
                try? self?.lightMeter.getIsoValue(
                    ev: ev,
                    shutterSpeed: shutterSpeed,
                    aperture: aperture
                )
            }
            .assign(to: &$iso)
        
        $exposureValue.combineLatest($iso, $aperture)
            .filter { [weak self] _ in
                self?.isShutterSpeedMode == true
            }
            .compactMap { [weak self] ev, iso, aperture in
                try? self?.lightMeter.getShutterSpeedValue(
                    ev: ev,
                    iso: iso,
                    aperture: aperture
                )
            }
            .assign(to: &$shutterSpeed)
        
        $exposureValue.combineLatest($iso, $shutterSpeed)
            .filter { [weak self] _ in
                self?.isApertureMode == true
            }
            .compactMap { [weak self] ev, iso, shutterSpeed in
                try? self?.lightMeter.getApertureValue(
                    ev: ev,
                    iso: iso,
                    shutterSpeed: shutterSpeed
                )
            }
            .assign(to: &$aperture)
        
    }
    
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
