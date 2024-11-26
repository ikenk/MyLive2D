//
//  LFaceTrackingViewModel.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/18.
//

import ARKit
import Foundation
import RealityKit

class LARFaceTrackingViewModel: NSObject, ObservableObject {
    @Published var arView: ARView = {
        let view = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: false)
        
        // 添加所有可用的调试选项来查看
        view.debugOptions = [
            .showStatistics,
            .showFeaturePoints,
            .showAnchorOrigins, // 显示锚点位置
            .showAnchorGeometry // 显示锚点几何体
        ]
        
        return view
    }()
    
    private var faceAnchorEntity: AnchorEntity?
    
    let features = ["nose", "leftEye", "rightEye", "mouth"]
    let featureIndices = [[9], [1064], [42], [24, 25]]
    
    override init() {
        super.init()
        
        setupFaceTrackingSession()
        
        setupFaceAnchor()
    }
    
    func setupFaceTrackingSession() {
        // TODO: deal with fatalError()
        guard ARFaceTrackingConfiguration.isSupported else { fatalError() }
        
        let config = ARFaceTrackingConfiguration()
        config.maximumNumberOfTrackedFaces = 1
        config.isLightEstimationEnabled = true
        
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        arView.session.delegate = self
    }
    
    private func setupFaceAnchor(){
        // 移除现有的 anchor
        if let existingAnchorEntity = faceAnchorEntity {
            print("移除现有的 anchor")
            arView.scene.removeAnchor(existingAnchorEntity)
        }
        
        faceAnchorEntity = AnchorEntity(.face)
        
        guard let faceAnchorEntity = faceAnchorEntity else { return }
        
        arView.scene.addAnchor(faceAnchorEntity)
    }
    

}

extension LARFaceTrackingViewModel: ARSessionDelegate{
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        print("LARFaceTrackingViewModel")
    }
}
