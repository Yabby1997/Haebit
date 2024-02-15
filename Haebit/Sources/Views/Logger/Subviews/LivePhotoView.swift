//
//  LivePhotoView.swift
//  HaebitDev
//
//  Created by Seunghun on 1/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import SwiftUI
import PhotosUI

struct LivePhoto: Equatable {
    let image: URL
    let video: URL?
}

struct LivePhotoView: View {
    let livePhoto: LivePhoto
    @State private var photo: PHLivePhoto?
    
    var body: some View {
        VStack {
            PHLivePhotoRepresentable(livePhoto: $photo)
                .aspectRatio((photo?.size.width ?? 1) / (photo?.size.height ?? 1), contentMode: .fill)
        }
        .onAppear {
            PHLivePhoto.request(
                withResourceFileURLs: [livePhoto.image, livePhoto.video].compactMap { $0 },
                placeholderImage: UIImage(contentsOfFile: livePhoto.image.relativePath),
                targetSize: .zero,
                contentMode: .aspectFill
            ) { photo, _ in
                Task { @MainActor in
                    self.photo = photo
                }
            }
        }
    }
}

struct PHLivePhotoRepresentable: UIViewRepresentable {
    @Binding var livePhoto: PHLivePhoto?
    
    func makeUIView(context: Context) -> PHLivePhotoView {
        let view = PHLivePhotoView()
        return view
    }
    
    func updateUIView(_ view: PHLivePhotoView, context: Context) {
        view.livePhoto = livePhoto
        view.startPlayback(with: .hint)
    }
}
