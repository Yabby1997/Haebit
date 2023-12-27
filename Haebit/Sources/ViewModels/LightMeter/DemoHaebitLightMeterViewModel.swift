//
//  DemoHaebitLightMeterViewModel.swift
//  Haebit
//
//  Created by Seunghun on 12/10/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation
import QuartzCore

final class DemoHaebitLightMeterViewModel: HaebitLightMeterViewModelProtocol {
    
    private let availableFocalLengths: [Int] = [28, 35, 40, 50, 70, 85, 100, 135, 200]
    private let availableApertureValues: [Float] = [1.0, 1.4, 2.0, 2.8, 4.0, 5.6, 8.0, 11, 16, 22]
    private let availableShutterSpeedDenominators: [Float] = [8000, 4000, 2000, 1000, 500, 250, 125, 60, 30, 15, 8, 4, 2, 1, 0.5, 0.25, 0.125, 0.0625, 0.03333333, 0.01666666]
    private let availableIsoValues: [Int] = [25, 50, 100, 200, 400, 800, 1600, 3200, 6400, 12800, 25600, 51200]
    
    var previewLayer: CALayer { CALayer() }
    var focalLengths: [FocalLengthValue] { availableFocalLengths.map { FocalLengthValue(value: $0) } }
    var apertureValues: [ApertureValue] { availableApertureValues.map { ApertureValue(value: $0) } }
    var shutterSpeedValues: [ShutterSpeedValue] { availableShutterSpeedDenominators.map { ShutterSpeedValue(denominator: $0) } }
    var isoValues: [IsoValue] { availableIsoValues.map { IsoValue(iso: $0) } }
    var resultDescription: String { ShutterSpeedValue(denominator: 60).description }
    var apertureMode: Bool { lightMeterMode == .aperture }
    var shutterSpeedMode: Bool { lightMeterMode == .shutterSpeed }
    var isoMode: Bool { lightMeterMode == .iso }
    var exposureValue: Float = 11
    var shouldRequestCameraAccess: Bool = false
    var lightMeterMode: LightMeterMode = .shutterSpeed
    var focalLength: FocalLengthValue = FocalLengthValue(value: 50)
    var aperture: ApertureValue = ApertureValue(value: 1.4)
    var shutterSpeed: ShutterSpeedValue = ShutterSpeedValue(denominator: 60)
    var iso: IsoValue = IsoValue(iso: 400)
    var lockPoint: CGPoint? = nil
    var isLocked: Bool = false
    
    func setupIfNeeded() {}
    func prepareInactive() {}
    func didTap(point: CGPoint) {}
    func didTapUnlock() {}
}
