//
//  DemoLightMeterConfigViewModel.swift
//  LightMeterFeature
//
//  Created by Seunghun on 7/13/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

@preconcurrency import Combine
import CoreGraphics
import Foundation
import HaebitCommonModels
import LightMeterFeature

@MainActor
final class DemoLightMeterConfigViewModel: ObservableObject {
    private let camera: MockLightMeterCamera
    private let preferenceProvider: MockLightMeterPreferenceProvider
    private let orientationObserver: MockOrientationObserver
    
    @Published var previewImage: CGImage?
    @Published var orientation: Orientation
    @Published var aperture: String
    @Published var shutterSpeed: String
    @Published var iso: String
    @Published var lockPointX: String = ""
    @Published var lockPointY: String = ""
    @Published var isLocked: Bool
    @Published var apertures: String
    @Published var shutterSpeeds: String
    @Published var isos: String
    @Published var focalLengths: String
    @Published var apertureFeedbackStyle: FeedbackStyle
    @Published var shutterSpeedFeedbackStyle: FeedbackStyle
    @Published var isoFeedbackStyle: FeedbackStyle
    @Published var focalLengthFeedbackStyle: FeedbackStyle
    @Published var previewType: PreviewType
    @Published var filmCanister: FilmCanister
    
    init(
        camera: MockLightMeterCamera,
        preferenceProvider: MockLightMeterPreferenceProvider,
        orientationObserver: MockOrientationObserver
    ) {
        self.camera = camera
        self.preferenceProvider = preferenceProvider
        self.orientationObserver = orientationObserver
        self.previewImage = camera.previewImageSubject.value
        self.orientation = orientationObserver._orientation
        self.aperture = String(camera.apertureSubject.value)
        self.shutterSpeed = String(camera.shutterSpeedSubject.value)
        self.iso = String(camera.isoSubject.value)
        if let lockPoint = camera.lockPointSubject.value {
            self.lockPointX = String(Float(lockPoint.x))
            self.lockPointY = String(Float(lockPoint.y))
        }
        self.isLocked = camera.isLockedSubject.value
        self.apertures = preferenceProvider.rawApertures
        self.shutterSpeeds = preferenceProvider.rawShutterSpeeds
        self.isos = preferenceProvider.rawIsos
        self.focalLengths = preferenceProvider.rawFocalLengths
        self.apertureFeedbackStyle = preferenceProvider.apertureRingFeedbackStyle
        self.shutterSpeedFeedbackStyle = preferenceProvider.shutterSpeedDialFeedbackStyle
        self.isoFeedbackStyle = preferenceProvider.isoDialFeedbackStyle
        self.focalLengthFeedbackStyle = preferenceProvider.focalLengthRingFeedbackStyle
        self.previewType = preferenceProvider.previewType
        self.filmCanister = preferenceProvider.filmCanister
        Task {
            await camera.setCamera(isOn: false)
        }
    }
    
    func didTapResetLock() {
        Task {
            lockPointX = ""
            lockPointY = ""
            isLocked = false
        }
    }
    
    func didTapDismiss() {
        Task {
            camera.previewImageSubject.send(previewImage)
            orientationObserver._orientation = orientation
            if let aperture = Float(aperture) { camera.apertureSubject.send(aperture) }
            if let shutterSpeed = Float(shutterSpeed) { camera.shutterSpeedSubject.send(shutterSpeed) }
            if let iso = Float(iso) { camera.isoSubject.send(iso) }
            if let lockPointX = Float(lockPointX), let lockPointY = Float(lockPointY) {
                camera.lockPointSubject.send(CGPoint(x: CGFloat(lockPointX), y: CGFloat(lockPointY)))
            } else {
                camera.lockPointSubject.send(nil)
            }
            camera.isLockedSubject.send(isLocked)
            preferenceProvider.rawApertures = apertures
            preferenceProvider.rawShutterSpeeds = shutterSpeeds
            preferenceProvider.rawIsos = isos
            preferenceProvider.rawFocalLengths = focalLengths
            preferenceProvider.apertureRingFeedbackStyle = apertureFeedbackStyle
            preferenceProvider.shutterSpeedDialFeedbackStyle = shutterSpeedFeedbackStyle
            preferenceProvider.isoDialFeedbackStyle = isoFeedbackStyle
            preferenceProvider.focalLengthRingFeedbackStyle = focalLengthFeedbackStyle
            preferenceProvider.previewType = previewType
            preferenceProvider.filmCanister = filmCanister
            await camera.setCamera(isOn: true)
        }
    }
}
