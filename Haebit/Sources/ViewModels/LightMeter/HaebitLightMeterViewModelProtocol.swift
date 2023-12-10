//
//  HaebitLightMeterViewModelProtocol.swift
//  Haebit
//
//  Created by Seunghun on 12/10/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation
import QuartzCore

protocol HaebitLightMeterViewModelProtocol: ObservableObject {
    var previewLayer: CALayer { get }
    var apertureValues: [ApertureValue] { get }
    var shutterSpeedValues: [ShutterSpeedValue] { get }
    var isoValues: [IsoValue] { get }
    var resultDescription: String { get }
    var apertureMode: Bool { get }
    var shutterSpeedMode: Bool { get }
    var isoMode: Bool { get }
    var exposureValue: Float { get }
    
    var shouldRequestCameraAccess: Bool { get set }
    var lightMeterMode: LightMeterMode { get set }
    var aperture: ApertureValue { get set }
    var shutterSpeed: ShutterSpeedValue { get set }
    var iso: IsoValue { get set }
    var lockPoint: CGPoint? { get set }
    var isLocked: Bool { get set }
    
    func setupIfNeeded()
    func didTap(point: CGPoint)
    func didTapUnlock()
}