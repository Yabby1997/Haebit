//
//  HaebitLightMeterViewModelProtocol.swift
//  Haebit
//
//  Created by Seunghun on 12/10/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import Foundation
import QuartzCore

@MainActor
protocol HaebitLightMeterViewModelProtocol: ObservableObject {
    var previewLayer: CALayer { get }
    var resultDescription: String { get }
    var apertureMode: Bool { get }
    var shutterSpeedMode: Bool { get }
    var isoMode: Bool { get }
    var exposureValue: Float { get }
    var shouldRequestReview: Bool { get }
    var isCapturing: Bool { get }
    var isPresentingLogger: Bool { get set }
    
    var shouldRequestCameraAccess: Bool { get set }
    var shouldRequestGPSAccess: Bool { get set }
    var lightMeterMode: LightMeterMode { get set }
    var focalLength: FocalLengthValue { get set }
    var apertureValues: [ApertureValue] { get set }
    var shutterSpeedValues: [ShutterSpeedValue] { get set }
    var isoValues: [IsoValue] { get set }
    var focalLengthValues: [FocalLengthValue] { get set }
    var aperture: ApertureValue { get set }
    var shutterSpeed: ShutterSpeedValue { get set }
    var iso: IsoValue { get set }
    var lockPoint: CGPoint? { get set }
    var isLocked: Bool { get set }
    
    func setupIfNeeded()
    func prepareInactive()
    func didTap(point: CGPoint)
    func didTapUnlock()
    func didTapShutter()
    func didTapDoNotAskGPSAccess()
    func didTapLogger()
    func didCloseLogger()
    func filmLogViewModel() -> HaebitFilmLogViewModel
}
