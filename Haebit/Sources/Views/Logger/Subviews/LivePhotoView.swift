//
//  LivePhotoView.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import PhotosUI

struct CaptureResult: Equatable {
    let image: URL
    let video: URL
}

struct LivePhotoView: UIViewRepresentable, Equatable {
    var result: CaptureResult
    
    func makeUIView(context: Context) -> PHLivePhotoView {
        let view = PHLivePhotoView()
        view.contentMode = .scaleAspectFit
        return view
    }
    
    func updateUIView(_ view: PHLivePhotoView, context: Context) {
        PHLivePhoto.request(
            withResourceFileURLs: [result.image, result.video],
            placeholderImage: nil,
            targetSize: .zero,
            contentMode: .aspectFit
        ) { photo, x in
            guard let photo else { return }
            view.livePhoto = photo
            view.startPlayback(with: .hint)
        }
    }
}
