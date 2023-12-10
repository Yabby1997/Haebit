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
    var previewLayer: CALayer { CALayer() }
    var apertureValues: [ApertureValue] { [ApertureValue(value: 1.4)] }
    var shutterSpeedValues: [ShutterSpeedValue] { [ShutterSpeedValue(denominator: 60)] }
    var isoValues: [IsoValue] { [IsoValue(iso: 400)] }
    var resultDescription: String { ShutterSpeedValue(denominator: 60).description }
    var apertureMode: Bool { lightMeterMode == .aperture }
    var shutterSpeedMode: Bool { lightMeterMode == .shutterSpeed }
    var isoMode: Bool { lightMeterMode == .iso }
    var exposureValue: Float = 11
    var shouldRequestCameraAccess: Bool = false
    var lightMeterMode: LightMeterMode = .shutterSpeed
    var aperture: ApertureValue = ApertureValue(value: 1.4)
    var shutterSpeed: ShutterSpeedValue = ShutterSpeedValue(denominator: 60)
    var iso: IsoValue = IsoValue(iso: 400)
    var lockPoint: CGPoint? = nil
    var isLocked: Bool = false
    
    func setupIfNeeded() {}
    func didTap(point: CGPoint) {}
    func didTapUnlock() {}
}
