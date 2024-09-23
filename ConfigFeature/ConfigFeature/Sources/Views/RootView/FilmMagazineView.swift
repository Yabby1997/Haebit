//
//  FilmMagazineView.swift
//  ConfigFeature
//
//  Created by Seunghun on 9/24/24.
//  Copyright © 2024 seunghun. All rights reserved.
//

import CoreMotion
import SceneKit
import SceneKit.ModelIO
import SwiftUI

struct FilmMagazineView: View {
    private let scene = FilmMagazineScene()
    var body: some View {
        SceneView(scene: scene, pointOfView: scene.cameraNode)
            .edgesIgnoringSafeArea(.all)
    }
}

class FilmMagazineScene: SCNScene {
    var cameraNode: SCNNode?
    var motionManager = CMMotionManager()
    
    @MainActor
    override init() {
        super.init()
        addCamera()
        addBoxes()
        addOmniLight()
        configureBackground()
        configureCoreMotion()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @MainActor
    func addCamera() {
        let camera = SCNCamera()
        cameraNode = SCNNode()
        cameraNode?.camera = camera
        cameraNode?.position = SCNVector3(x: 0, y: 15, z: 15)
        cameraNode?.look(at: SCNVector3(0, 0, 0))
        self.rootNode.addChildNode(cameraNode!)
    }
    
    @MainActor
    func addBoxes() {
        guard let url = Bundle(for: type(of: self)).url(forResource: "film", withExtension: "usdz") else {
            print("film.usdz not found")
            return
        }
        let asset = MDLAsset(url: url)
        asset.loadTextures()
        let modelNode = SCNNode(mdlObject: asset.object(at: .zero))
        modelNode.position = SCNVector3(0, 0, 0)
        modelNode.scale = SCNVector3(0.25, 0.25, 0.25)
        rootNode.addChildNode(modelNode)
    }
    
    @MainActor
    func addOmniLight() {
        let omniLightNode = SCNNode()
        omniLightNode.light = SCNLight()
        omniLightNode.light?.type = .ambient
        omniLightNode.light?.color = UIColor.yellow
        omniLightNode.position = SCNVector3Make(10, 15, 10)
        self.rootNode.addChildNode(omniLightNode)
    }
    
    func configureBackground() {
        background.contents = UIColor.black
    }
    
    @MainActor
    func configureCoreMotion() {
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceMotion, error in
            guard let motion = deviceMotion, let cameraNode = self?.cameraNode else { return }
            let rollLimit: Float = 0.5
            let pitchLimit: Float = 0.5
            let adjustedRoll = min(max(Float(motion.attitude.roll), -rollLimit), rollLimit)
            let adjustedPitch = min(max(Float(motion.attitude.pitch), -pitchLimit), pitchLimit)
            cameraNode.position = SCNVector3(
                x: 10 * cos(adjustedRoll * 2),
                y: 5 + adjustedPitch * 2,
                z: 10 * sin(adjustedRoll * 2)
            )
            cameraNode.look(at: SCNVector3(0, 0, 0))
        }
    }
}
