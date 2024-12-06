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
        let view = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        // 添加所有可用的调试选项来查看
        view.debugOptions = [
            .showStatistics,
//            .showFeaturePoints,
//            .showAnchorOrigins, // 显示锚点位置
//            .showAnchorGeometry // 显示锚点几何体
        ]
        
        return view
    }()
    
    private var faceAnchorEntity: AnchorEntity?
    private var modelEntity: ModelEntity?
    
    // 控制更新频率
    private var updateCounter = 0
    private let updateInterval = 5 // 每5帧更新一次
    
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
    
    private func setupFaceAnchor() {
        // 移除现有的 anchor
        if let existingAnchorEntity = faceAnchorEntity {
            print("[MyLog]移除现有的 anchor")
            arView.scene.removeAnchor(existingAnchorEntity)
        }
        
        faceAnchorEntity = AnchorEntity(.face)
        
        guard let faceAnchorEntity = faceAnchorEntity else { return }
        
        arView.scene.addAnchor(faceAnchorEntity)
    }
}

// MARK: ARSessionDelegate
extension LARFaceTrackingViewModel: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
//        session.add(anchor: faceAnchor) // 移除对 session.add(anchor: faceAnchor) 的调用，因为这是重复的,系统已经在追踪这个锚点了
        
        updateCounter += 1
        if updateCounter % updateInterval == 0 {
            updateCounter = 0
            return
        }
        
        if modelEntity != nil {
            modelEntity?.removeFromParent()
        }
        
        guard let eyeBlinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft] as? Float,
              let eyeBlinkRight = faceAnchor.blendShapes[.eyeBlinkRight] as? Float,
              let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? Float,
              let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float
        else { return }
        
        My_LAppLive2DManager.shared().setModelParamter((1 - eyeBlinkLeft), forID: ParamEyeLOpen)
        My_LAppLive2DManager.shared().setModelParamter((1 - eyeBlinkRight), forID: ParamEyeROpen)
        My_LAppLive2DManager.shared().setModelParamter(jawOpen * 1.5, forID: ParamMouthOpenY)
        My_LAppLive2DManager.shared().setModelParamter(1 - mouthFunnel * 2, forID: ParamMouthForm)
        
//        createFaceMask(from: faceAnchor)
        
//        print("[MyLog]faceAnchor.geometry.vertices: \(faceAnchor.geometry.vertices)")
//        print("[MyLog]faceAnchor.geometry.triangleCount: \(faceAnchor.geometry.triangleCount)")
//        print("[MyLog]faceAnchor.geometry.triangleIndices: \(faceAnchor.geometry.triangleIndices)")
//        print("[MyLog]faceAnchor.transform: \(faceAnchor.transform)")
//        print("[MyLog]faceAnchor.blendShapes[.eyeBlinkRight]: \(faceAnchor.blendShapes[.eyeBlinkRight])")
    }
}

// MARK: Create Face Mask
extension LARFaceTrackingViewModel {
    func createFaceMask(from faceAnchor: ARFaceAnchor) {
        // 创建网格材质
        var material = SimpleMaterial()
        material.color = .init(tint: .gray.withAlphaComponent(0.5))
        material.metallic = 0.0
        material.roughness = 1.0
        
        // 创建网格描述符
        let meshDescriptor: MeshDescriptor = createWireMeshDescriptor(from: faceAnchor)
        do {
            // 创建网格模型
            let mesh: MeshResource = try .generate(from: [meshDescriptor])
            self.modelEntity = ModelEntity(mesh: mesh, materials: [material])
            
            guard let faceAnchorEntity = faceAnchorEntity, let modelEntity = modelEntity else { return }
            modelEntity.position = .init(x: 0, y: 0, z: 0.01)
//            modelEntity.setPosition(.init(x: 0, y: 0, z: 0.1), relativeTo: faceAnchorEntity)
            faceAnchorEntity.addChild(modelEntity)
        } catch {
            print("[MyLog]Error: \(error)")
        }
    }

    func createWireMeshDescriptor(from anchor: ARFaceAnchor) -> MeshDescriptor {
        let vertices: [simd_float3] = anchor.geometry.vertices
        var triangleIndices: [UInt32] = []
        let texCoords: [simd_float2] = anchor.geometry.textureCoordinates
        
        // 采样顶点，只使用部分顶点
//        let sampleRate = 3 // 每3个顶点取1个
//        let sampleVertices: [simd_float3] = stride(from: 0, to: vertices.count, by: sampleRate).map { index in
//            vertices[index]
//        }
//
//        for index in anchor.geometry.triangleIndices {
//            if Int(UInt32(index)) % sampleRate == 0 {
//                triangleIndices.append(UInt32(index))
//            } else {
//                continue
//            }
//        }
        
        for index in anchor.geometry.triangleIndices {
            triangleIndices.append(UInt32(index))
        }
        
        var descriptor = MeshDescriptor(name: "Face_Mesh")
        // 设置顶点位置
        descriptor.positions = MeshBuffers.Positions(vertices)
        // 设置三角形索引
        descriptor.primitives = .triangles(triangleIndices)
        // 设置纹理坐标
        descriptor.textureCoordinates = MeshBuffers.TextureCoordinates(texCoords)
        
        return descriptor
    }
}
