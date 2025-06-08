//
//  ImageRotator.swift
//  LightMeterFeature
//
//  Created by Seunghun on 6/8/25.
//  Copyright © 2025 seunghun. All rights reserved.
//

@preconcurrency import CoreImage
import Foundation

actor ImageRoatator {
    private let ciContext = CIContext()
    
    func rotateImage(_ image: CGImage) async -> CGImage? {
        await withCheckedContinuation { continuation in
            let ciImage = CIImage(cgImage: image)
            let transform = CGAffineTransform(translationX: -ciImage.extent.midX, y: -ciImage.extent.midY)
                .rotated(by: -.pi / 2)
                .translatedBy(x: ciImage.extent.midY, y: ciImage.extent.midX)
            let rotated = ciImage.transformed(by: transform)
            let result = ciContext.createCGImage(rotated, from: rotated.extent.integral)
            continuation.resume(returning: result)
        }
    }
}
