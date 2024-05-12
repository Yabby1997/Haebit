//
//  MockHaebitLightMeterViewModel.swift
//  Haebit
//
//  Created by Seunghun on 12/10/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation
import HaebitCommonModels
import HaebitLogger
import LightMeter
import QuartzCore

public final class MockHaebitLightMeterViewModel: HaebitLightMeterViewModelProtocol {
   // MARK: - Constants
    
    private let availableApertureValues: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    private let availableShutterSpeedDenominators: [Float] = [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2]
    private let availableShutterSpeedSeconds: [Int] = [1, 2, 4, 8, 16, 30, 60]
    private let availableIsoValues: [Int] = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200]
    private let availableFocalLengths: [Int] = [28, 35, 40, 50, 70, 85, 100, 135, 200]
    
    public var previewLayer: CALayer { CALayer() }
    public var resultDescription: String {
        switch lightMeterMode {
        case .aperture: return aperture.description
        case .shutterSpeed: return shutterSpeed.description
        case .iso: return iso.description
        }
    }
    
    public var apertureMode: Bool { lightMeterMode == .aperture }
    public var shutterSpeedMode: Bool { lightMeterMode == .shutterSpeed }
    public var isoMode: Bool { lightMeterMode == .iso }
    @Published public var exposureValue: Float = 11
    public var shouldRequestCameraAccess: Bool = false
    public var shouldRequestGPSAccess: Bool = false
    @Published public var lightMeterMode: LightMeterMode
    @Published var shutterSpeedInNanoSeconds: UInt64 = 1_000_000_000
    @Published public var apertureValues: [ApertureValue] = []
    @Published public var shutterSpeedValues: [ShutterSpeedValue] = []
    @Published public var isoValues: [IsoValue] = []
    @Published public var focalLengthValues: [FocalLengthValue] = []
    @Published public var aperture: ApertureValue
    @Published public var shutterSpeed: ShutterSpeedValue
    @Published public var iso: IsoValue
    @Published public var focalLength: FocalLengthValue = FocalLengthValue(value: 50)
    public var isCapturing: Bool { true }
    public var lockPoint: CGPoint? = nil
    public var isLocked: Bool = false
    public var shouldRequestReview: Bool { false }
    public var isPresentingLogger = false
    
    public init(
        exposureValue: Float = 11,
        lightMeterMode: LightMeterMode = .shutterSpeed,
        aperture: ApertureValue = ApertureValue(value: 1.4),
        shutterSpeed: ShutterSpeedValue = ShutterSpeedValue(denominator: 60)!,
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
        apertureValues = availableApertureValues.map { ApertureValue(value: $0) }
        shutterSpeedValues = availableShutterSpeedDenominators.compactMap { ShutterSpeedValue(denominator: $0) }
            + availableShutterSpeedSeconds.compactMap { ShutterSpeedValue(seconds: $0) }
        isoValues = availableIsoValues.map { IsoValue(iso: $0) }
        focalLengthValues = availableFocalLengths.map { FocalLengthValue(value: $0) }
        bind()
    }
    
    private func bind() {
        $exposureValue.combineLatest($shutterSpeed, $aperture)
            .filter { [weak self] _ in
                self?.lightMeterMode == .iso
            }
            .compactMap { [weak self] ev, shutterSpeed, aperture in
                guard let self else { return nil }
                let iso = try? LightMeterService.getIsoValue(
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
                let value = try? LightMeterService.getShutterSpeedValue(
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
                let aperture = try? LightMeterService.getApertureValue(
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
    
    public func setupIfNeeded() {}
    public func prepareInactive() {}
    public func didTap(point: CGPoint) {}
    public func didTapUnlock() {}
    public func didTapShutter() {}
    public func didTapDoNotAskGPSAccess() {}
    public func didTapLogger() {}
    public func didCloseLogger() {}
}
