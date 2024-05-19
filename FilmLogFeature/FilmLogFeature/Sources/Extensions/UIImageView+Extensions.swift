//
//  UIImageView+Extensions.swift
//  Haebit
//
//  Created by Seunghun on 4/16/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import UIKit

extension UIImageView {
    func setDownSampledImage(at url: URL) async {
        let size = frame.size
        let scale = window?.windowScene?.screen.scale ?? 3.0
        
        let cgImage: CGImage? = await Task.detached {
            let createOptions = [kCGImageSourceShouldCache: false] as CFDictionary
            let thumbnailOptions = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: max(size.width, size.height) * scale
            ] as CFDictionary
            
            guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, createOptions),
                  let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, .zero, thumbnailOptions) else {
                return nil
            }
            return cgImage
        }.value
        
        guard let cgImage else {
            setImage(nil)
            return
        }
        
        setImage(UIImage(cgImage: cgImage))
    }
    
    func setImage(_ image: UIImage?, withAnimation duration: TimeInterval = 0.3) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.image = image
        }
    }
}
