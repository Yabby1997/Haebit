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
                await self?.animateSet(image: nil, with: 0.2)
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
                await self?.animateSet(image: nil, with: 0.2)
                return
            }
            
            await self?.animateSet(image: UIImage(cgImage: cgImage), with: 0.2)
        }
    }
    
    private func animateSet(image: UIImage?, with duration: TimeInterval) {
        UIView.animate(withDuration: duration) { [weak self] in
            self?.image = image
        }
    }
}
