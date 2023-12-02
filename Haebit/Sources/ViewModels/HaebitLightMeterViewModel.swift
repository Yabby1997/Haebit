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
    private let availableIsoValues: [Int] = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200]
    private let availableShutterSpeedDenominators: [Int] = [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2, 1]
    private let availableApertureValues: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    
    private let camera = ObscuraCamera()
    private let lightMeter = LightMeterService()

    var previewLayer: CALayer { camera.previewLayer }
    
    var isoValues: [IsoValue] { availableIsoValues.map { IsoValue(iso: $0) } }
    var shutterSpeeds: [ShutterSpeedValue] { availableShutterSpeedDenominators.map { ShutterSpeedValue(denominator: $0) } }
    var apertureValues: [ApertureValue] { availableApertureValues.map { ApertureValue(value: $0) } }
    
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
    
    @Published var iso: IsoValue = IsoValue(iso: 200)
    @Published var shutterSpeed: ShutterSpeedValue = ShutterSpeedValue(denominator: 60)
    @Published var aperture: ApertureValue = ApertureValue(value: 1.4)

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
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$exposureValue)
        
        $exposureValue.combineLatest($shutterSpeed, $aperture)
            .filter { [weak self] _ in
                self?.isIsoMode == true
            }
            .compactMap { [weak self] ev, shutterSpeed, aperture in
                guard let self else { return nil }
                let iso = try? lightMeter.getIsoValue(
                    ev: ev,
                    shutterSpeed: shutterSpeed.value,
                    aperture: aperture.value
                )
                    .nearest(among: isoValues.map { $0.value } )
                return isoValues.first { $0.value == iso }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$iso)
        
        $exposureValue.combineLatest($iso, $aperture)
            .filter { [weak self] _ in
                self?.isShutterSpeedMode == true
            }
            .compactMap { [weak self] ev, iso, aperture in
                guard let self else { return nil }
                let value = try? lightMeter.getShutterSpeedValue(
                    ev: ev,
                    iso: iso.value,
                    aperture: aperture.value
                )
                .nearest(among: shutterSpeeds.map { $0.value } )
                return shutterSpeeds.first { $0.value == value }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$shutterSpeed)
        
        $exposureValue.combineLatest($iso, $shutterSpeed)
            .filter { [weak self] _ in
                self?.isApertureMode == true
            }
            .compactMap { [weak self] ev, iso, shutterSpeed in
                guard let self else { return nil }
                let aperture = try? lightMeter.getApertureValue(
                    ev: ev,
                    iso: iso.value,
                    shutterSpeed: shutterSpeed.value
                )
                    .nearest(among: apertureValues.map { $0.value } )
                return apertureValues.first { $0.value == aperture }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
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
