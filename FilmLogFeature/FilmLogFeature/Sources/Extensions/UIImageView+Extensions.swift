//
//  UIImageView+Extensions.swift
//  Haebit
//
//  Created by Seunghun on 4/16/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

extension UIImageView {
    func setDownSampledImage(at url: URL) {
        let size = frame.size
        let scale = window?.windowScene?.screen.scale ?? 3.0
        
        Task.detached { [weak self] in
            guard let imageSource = CGImageSourceCreateWithURL(
                url as CFURL,
                [kCGImageSourceShouldCache: false] as CFDictionary
            ) else {
                await self?.setImage(nil, withAnimation: 0.3)
                return
            }
            
            let maxDimensionInPixels = max(size.width, size.height) * scale
            let downsampleOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
            ] as CFDictionary

            guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions)else {
                await self?.setImage(nil, withAnimation: 0.3)
                return
            }
            
            await self?.setImage(UIImage(cgImage: cgImage), withAnimation: 0.3)
        }
    }
    
    func setImage(_ image: UIImage?, withAnimation duration: TimeInterval) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.image = image
        }
    }
}
