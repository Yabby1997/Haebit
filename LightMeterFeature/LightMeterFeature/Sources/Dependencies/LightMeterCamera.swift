//
//  LightMeterCamera.swift
//  LightMeterFeature
//
//  Created by Seunghun on 7/11/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import Combine
import Foundation
import QuartzCore

/// Errors that can occur while using ``LightMeterCamera``.
public enum LightMeterCameraErrors: Error {
    /// Indicates that camera access is not authorized.
    case notAuthorized
    /// Indicates that setup is not done properly.
    case setupRequired
    /// Indicates that the action requested is not supported.
    case notSupported
    /// Indicates that the capturing has been failed.
    case failedToCapture
}

public protocol LightMeterCamera: Actor {
    /// The layer that camera feed will be rendered on.
    nonisolated var previewLayer: CALayer { get }
    
    /// A `Bool` value indicating whether the camera is running.
    nonisolated var isRunning: AnyPublisher<Bool, Never> { get }
    /// A `CGFloat` value indicating the minimum zoom factor.
    nonisolated var minZoomFactor: AnyPublisher<CGFloat, Never> { get }
    /// A `CGFloat` value indicating the maximum zoom factor.
    nonisolated var maxZoomFactor: AnyPublisher<CGFloat, Never> { get }
    /// A `Bool` value indicating whether the HDR mode is enabled.
    nonisolated var isHDREnabled: AnyPublisher<Bool, Never> { get }
    /// The ISO value that the camera is currently using.
    nonisolated var iso: AnyPublisher<Float, Never> { get }
    /// The Shutter speed value that the camera is currently using.
    nonisolated var shutterSpeed: AnyPublisher<Float, Never> { get }
    /// The Aperture f-number value that the camera is currently using.
    nonisolated var aperture: AnyPublisher<Float, Never> { get }
    /// A `CGPoint` value indicating which point is being used for exposure lock.
    nonisolated var exposureLockPoint: AnyPublisher<CGPoint?, Never> { get }
    /// A `CGPoint` value indicating which point is being used for focus lock.
    nonisolated var focusLockPoint: AnyPublisher<CGPoint?, Never> { get }
    /// A `Bool` value indicating whether the exposure is locked.
    nonisolated var isExposureLocked: AnyPublisher<Bool, Never> { get }
    /// A `Bool` value indicating whether the focus is locked.
    nonisolated var isFocusLocked: AnyPublisher<Bool, Never> { get }
    /// A `CGFloat` value indicating the current zoom factor.
    nonisolated var zoomFactor: AnyPublisher<CGFloat, Never> { get }
    /// A `Bool` value indicating the camera is currently capturing.
    nonisolated var isCapturing: AnyPublisher<Bool, Never> { get }
    /// A `Float` value representing the metered exposure level in stops.
    nonisolated var exposureValue: AnyPublisher<Float, Never> { get }
    /// A `Float` value representing the difference between the metered exposure level and the current exposure settings in stops.
    nonisolated var exposureOffset: AnyPublisher<Float, Never> { get }
    
    
    /// Sets up the Camera.
    ///
    /// - Throws: Errors that occurred while configuring the camera, including authorization error.
    func setup() async throws
    
    /// Starts camera session.
    func start() async
    
    /// Stops camera session.
    func stop() async
    
    /// Sets the zoom factor.
    ///
    /// - Parameters:
    ///     - factor: The zoom factor.
    func zoom(factor: CGFloat) async throws
    
    /// Sets the HDR mode.
    ///
    /// - Note: Subscribe ``isHDREnabled`` to receive update of HDR mode.
    ///
    /// - Parameters:
    ///     - isEnabled: Whether or not to enable the HDR mode.
    func setHDRMode(isEnabled: Bool) async throws
    
    /// Sets the mute status.
    ///
    /// - Parameters:
    ///     - isMuted: The mute state to be set.
    func setMute(_ isMuted: Bool) async

    /// Locks the exposure on certain point.
    ///
    /// - Note: Unlock the exposure using ``unlockExposure()``
    ///
    /// - Parameters:
    ///     - point: The certain point on ``previewLayer`` to lock exposure.
    func lockExposure(on point: CGPoint) async throws
    
    /// Sets the exposure bias level.
    ///
    /// - Parameters:
    ///   - bias: The exposure bias in stops.
    func setExposure(bias: Float) async throws
    
    /// Unlocks the exposure.
    func unlockExposure() async throws
    
    /// Locks the focus on certain point.
    ///
    /// - Note: Unlock the focus using ``unlockFocus()``
    ///
    /// - Parameters:
    ///     - point: The certain point on ``previewLayer`` to lock focus.
    func lockFocus(on point: CGPoint) async throws
    
    /// Unlocks the focus.
    func unlockFocus() async throws
    
    /// Captures a photo.
    ///
    /// - Important: Returns `nil` if the camera is currently busy with a previous capture request.
    /// - Returns: A URL `String` indicating the path of result image in the app sandbox.
    /// - Throws: Errors that might occur while capturing the photo.
    func capturePhoto() async throws -> String?
}
