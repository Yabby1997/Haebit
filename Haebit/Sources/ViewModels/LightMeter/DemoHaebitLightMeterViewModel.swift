//
//  DemoHaebitLightMeterViewModel.swift
//  Haebit
//
//  Created by Seunghun on 12/10/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation
import QuartzCore
import LightMeter
import HaebitLogger

final class DemoHaebitLightMeterViewModel: HaebitLightMeterViewModelProtocol {
    private let lightMeter = LightMeterService()
    
    // MARK: - Constants
    
    private let availableApertureValues: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    private let availableShutterSpeedDenominators: [Float] = [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2, 1, 0.5, 0.25, 0.125, 0.0625, 0.03333333, 0.01666666]
    private let availableIsoValues: [Int] = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200]
    private let availableFocalLengths: [Int] = [28, 35, 40, 50, 70, 85, 100, 135, 200]
    
    var previewLayer: CALayer { CALayer() }
    var apertureValues: [ApertureValue] { availableApertureValues.map { ApertureValue(value: $0) } }
    var shutterSpeedValues: [ShutterSpeedValue] { availableShutterSpeedDenominators.map { ShutterSpeedValue(denominator: $0) } }
    var isoValues: [IsoValue] { availableIsoValues.map { IsoValue(iso: $0) } }
    var focalLengths: [FocalLengthValue] { availableFocalLengths.map { FocalLengthValue(value: $0) } }
    var resultDescription: String {
        switch lightMeterMode {
        case .aperture: return aperture.description
        case .shutterSpeed: return shutterSpeed.description
        case .iso: return iso.description
        }
    }
    
    var apertureMode: Bool { lightMeterMode == .aperture }
    var shutterSpeedMode: Bool { lightMeterMode == .shutterSpeed }
    var isoMode: Bool { lightMeterMode == .iso }
    @Published var exposureValue: Float = 11
    var shouldRequestCameraAccess: Bool = false
    var shouldRequestGPSAccess: Bool = false
    @Published var lightMeterMode: LightMeterMode
    @Published var shutterSpeedInNanoSeconds: UInt64 = 1_000_000_000
    @Published var aperture: ApertureValue
    @Published var shutterSpeed: ShutterSpeedValue
    @Published var iso: IsoValue
    @Published var focalLength: FocalLengthValue = FocalLengthValue(value: 50)
    var isCapturing: Bool { true }
    var lockPoint: CGPoint? = nil
    var isLocked: Bool = false
    var shouldRequestReview: Bool { false }
    var isPresentingLogger = false
    
    init(
        exposureValue: Float = 11,
        lightMeterMode: LightMeterMode = .shutterSpeed,
        aperture: ApertureValue = ApertureValue(value: 1.4),
        shutterSpeed: ShutterSpeedValue = ShutterSpeedValue(denominator: 60),
        iso: IsoValue = IsoValue(iso: 400),
        focalLength: FocalLengthValue = FocalLengthValue(value: 50),
        lockPoint: CGPoint? = nil,
        isLocked: Bool = false
    ) {
        
        self.exposureValue = exposureValue
        self.lightMeterMode = lightMeterMode
        self.aperture = aperture
        self.shutterSpeed = shutterSpeed
        self.iso = iso
        self.focalLength = focalLength
        self.lockPoint = lockPoint
        self.isLocked = isLocked
        bind()
    }
    
    private func bind() {
        $exposureValue.combineLatest($shutterSpeed, $aperture)
            .filter { [weak self] _ in
                self?.lightMeterMode == .iso
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
                self?.lightMeterMode == .shutterSpeed
            }
            .compactMap { [weak self] ev, iso, aperture in
                guard let self else { return nil }
                let value = try? lightMeter.getShutterSpeedValue(
                    ev: ev,
                    iso: iso.value,
                    aperture: aperture.value
                )
                    .nearest(among: shutterSpeedValues.map { $0.value } )
                return shutterSpeedValues.first { $0.value == value }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$shutterSpeed)
        
        $exposureValue.combineLatest($iso, $shutterSpeed)
            .filter { [weak self] _ in
                self?.lightMeterMode == .aperture
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
    
    func setupIfNeeded() {}
    func prepareInactive() {}
    func didTap(point: CGPoint) {}
    func didTapUnlock() {}
    func didTapShutter() {}
    func didTapDoNotAskGPSAccess() {}
    func didTapLogger() {}
    func didCloseLogger() {}
    func loggerViewModel() -> HaebitLoggerViewModel {
        .init(logger: HaebitLogger(repository: MockHaebitLogRepository()))
    }
}
