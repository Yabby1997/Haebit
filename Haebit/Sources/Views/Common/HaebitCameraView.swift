//
//  HaebitCameraView.swift
//  Haebit
//
//  Created by Seunghun on 11/29/23.
//  Copyright © 2023 seunghun. All rights reserved.
//

import SwiftUI

struct HaebitCameraView: UIViewRepresentable {
    private final class _CameraView: UIView {
        private let previewLayer: CALayer
        
        init(previewLayer: CALayer) {
            self.previewLayer = previewLayer
            super.init(frame: .zero)
            setupLayer()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            previewLayer.frame = layer.bounds
        }
        
        private func setupLayer() {
            previewLayer.backgroundColor = UIColor.black.cgColor
            layer.addSublayer(previewLayer)
        }
    }
    
    private let previewLayer: CALayer

    init(previewLayer: CALayer) {
        self.previewLayer = previewLayer
    }
    
    func makeUIView(context: Context) -> some UIView {
        _CameraView(previewLayer: previewLayer)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

