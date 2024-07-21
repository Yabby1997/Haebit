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

@MainActor
final class DemoLightMeterConfigViewModel: ObservableObject {
    private let camera: MockLightMeterCamera
    private let preferenceProvider: MockLightMeterPreferenceProvider
    
    @Published var previewImage: CGImage?
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
    
    init(
        camera: MockLightMeterCamera,
        preferenceProvider: MockLightMeterPreferenceProvider
    ) {
        self.camera = camera
        self.preferenceProvider = preferenceProvider
        self.previewImage = camera.previewImageSubject.value
        self.aperture = String(camera.apertureSubject.value)
        self.shutterSpeed = String(camera.shutterSpeedSubject.value)
        self.iso = String(camera.isoSubject.value)
        if let lockPoint = camera.lockPointSubject.value {
            self.lockPointX = String(Float(lockPoint.x))
            self.lockPointY = String(Float(lockPoint.y))
        }
        self.isLocked = camera.isLockedSubject.value
        self.apertures = preferenceProvider.apertures
        self.shutterSpeeds = preferenceProvider.shutterSpeeds
        self.isos = preferenceProvider.isos
        self.focalLengths = preferenceProvider.focalLengths
        self.apertureFeedbackStyle = preferenceProvider.apertureFeedbackStyle
        self.shutterSpeedFeedbackStyle = preferenceProvider.shutterSpeedFeedbackStyle
        self.isoFeedbackStyle = preferenceProvider.isoFeedbackStyle
        self.focalLengthFeedbackStyle = preferenceProvider.focalLengthFeedbackStyle
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
            if let aperture = Float(aperture) { camera.apertureSubject.send(aperture) }
            if let shutterSpeed = Float(shutterSpeed) { camera.shutterSpeedSubject.send(shutterSpeed) }
            if let iso = Float(iso) { camera.isoSubject.send(iso) }
            if let lockPointX = Float(lockPointX), let lockPointY = Float(lockPointY) {
                camera.lockPointSubject.send(CGPoint(x: CGFloat(lockPointX), y: CGFloat(lockPointY)))
            } else {
                camera.lockPointSubject.send(nil)
            }
            camera.isLockedSubject.send(isLocked)
            preferenceProvider.apertures = apertures
            preferenceProvider.shutterSpeeds = shutterSpeeds
            preferenceProvider.isos = isos
            preferenceProvider.focalLengths = focalLengths
            preferenceProvider.apertureFeedbackStyle = apertureFeedbackStyle
            preferenceProvider.shutterSpeedFeedbackStyle = shutterSpeedFeedbackStyle
            preferenceProvider.isoFeedbackStyle = isoFeedbackStyle
            preferenceProvider.focalLengthFeedbackStyle = focalLengthFeedbackStyle
            await camera.setCamera(isOn: true)
        }
    }
}
