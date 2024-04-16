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
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let size = frame.size
            let scale = window?.windowScene?.screen.scale ?? 3.0
            
            DispatchQueue.global().async {
                guard let imageSource = CGImageSourceCreateWithURL(
                    url as CFURL,
                    [kCGImageSourceShouldCache: false] as CFDictionary
                ) else {
                    return
                }
                
                let maxDimensionInPixels = max(size.width, size.height) * scale
                let downsampleOptions = [
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceShouldCacheImmediately: true,
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
                ] as CFDictionary
                
                guard let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
                    return
                }
                
                let downSampledImage = UIImage(cgImage: cgImage)
                
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 0.2) { [weak self] in
                        self?.image = downSampledImage
                    }
                }
            }
        }
    }
}
