//
//  DemoLightMeterViewModel.swift
//  Haebit
//
//  Created by Seunghun on 12/10/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation
import LightMeterFeature
import HaebitCommonModels
import LightMeter
import QuartzCore
import UIKit

final class DemoLightMeterViewModel: HaebitLightMeterViewModelProtocol {
   // MARK: - Constants
    
    private let availableApertureValues: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    private let availableShutterSpeedDenominators: [UInt32] = [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2]
    private let availableShutterSpeedNumerators: [UInt32] = [1, 2, 4, 8, 16, 30, 60]
    private let availableIsoValues: [UInt32] = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200]
    private let availableFocalLengths: [UInt32] = [28, 35, 40, 50, 70, 85, 100, 135, 200]
    
    nonisolated let previewLayer: CALayer
    var resultDescription: String {
        switch lightMeterMode {
        case .aperture: return aperture.description
        case .shutterSpeed: return shutterSpeed.description
        case .iso: return iso.description
        }
    }
    
    @Published var previewImage: CGImage?
    @Published var exposureValue: Float = 11
    @Published var lightMeterMode: LightMeterMode = .shutterSpeed
    @Published var shutterSpeedInNanoSeconds: UInt64 = 1_000_000_000
    @Published var apertureValues: [ApertureValue] = []
    @Published var shutterSpeedValues: [ShutterSpeedValue] = []
    @Published var isoValues: [IsoValue] = []
    @Published var focalLengthValues: [FocalLengthValue] = []
    @Published var aperture = ApertureValue(1.4)!
    @Published var shutterSpeed = ShutterSpeedValue(denominator: 60)!
    @Published var iso = IsoValue(400)!
    @Published var focalLength = FocalLengthValue(50)!
    @Published var lockPointX: Float?
    @Published var lockPointY: Float?
    @Published var lockPoint: CGPoint? = nil
    @Published var isLocked: Bool = false
    
    var apertureMode: Bool { lightMeterMode == .aperture }
    var shutterSpeedMode: Bool { lightMeterMode == .shutterSpeed }
    var isoMode: Bool { lightMeterMode == .iso }
    var shouldRequestCameraAccess: Bool = false
    var shouldRequestGPSAccess: Bool = false
    var isCapturing: Bool { false }
    var shouldRequestReview: Bool { false }
    var isPresentingLogger = false
    
    init() {
        previewLayer = CALayer()
        apertureValues = availableApertureValues.compactMap { ApertureValue($0) }
        shutterSpeedValues = availableShutterSpeedDenominators.compactMap { ShutterSpeedValue(denominator: $0) } + availableShutterSpeedNumerators.compactMap { ShutterSpeedValue(numerator: $0) }
        isoValues = availableIsoValues.compactMap { IsoValue($0) }
        focalLengthValues = availableFocalLengths.compactMap { FocalLengthValue($0) }
        bind()
    }
    
    private func bind() {
        $lockPointX.combineLatest($lockPointY)
            .map { x, y in
                guard let x, let y else { return nil }
                return CGPoint(x: CGFloat(x), y: CGFloat(y))
            }
            .assign(to: &$lockPoint)
        
        $exposureValue.combineLatest($shutterSpeed, $aperture)
            .filter { [weak self] _ in
                self?.lightMeterMode == .iso
            }
            .compactMap { [weak self] ev, shutterSpeed, aperture in
                guard let self else { return nil }
                let value = try? LightMeterService.getIsoValue(
                    ev: ev,
                    shutterSpeed: shutterSpeed.value,
                    aperture: aperture.value
                )
                    .nearest(among: isoValues.map { Float($0.value) } )
                return isoValues.first { Float($0.value) == value }
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
                    iso: Float(iso.value),
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
                    iso: Float(iso.value),
                    shutterSpeed: shutterSpeed.value
                )
                    .nearest(among: apertureValues.map { $0.value } )
                return apertureValues.first { $0.value == aperture }
            }
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .assign(to: &$aperture)
    }
    
    func setPreview(_ image: CGImage?) {
        let scale = UIScreen.main.scale
        CATransaction.begin()
        previewLayer.contents = image
        previewLayer.contentsGravity = .resizeAspectFill
        previewLayer.contentsScale = scale
        previewLayer.displayIfNeeded()
        CATransaction.commit()
        previewImage = image
    }
    
    func resetLock() {
        lockPointX = nil
        lockPointY = nil
        isLocked = false
    }
    
    func didTapUnlock() {}
    func setupIfNeeded() {}
    func prepareInactive() {}
    func didTap(point: CGPoint) {}
    func didTapShutter() {}
    func didTapDoNotAskGPSAccess() {}
    func didTapLogger() {}
    func didCloseLogger() {}
}
