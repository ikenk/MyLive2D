//
//  LFaceTrackingView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/19.
//

import ARKit
import RealityKit
import SwiftUI

struct LARFaceTrackingView: UIViewRepresentable {
    @EnvironmentObject var modelManager: LModelManager

    let arView: ARView = {
        let view = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        view.debugOptions = [
//            .showStatistics,
//            .showFeaturePoints,
//            .showAnchorOrigins, // 显示锚点位置
//            .showAnchorGeometry // 显示锚点几何体
        ]

        return view
    }()

    private func setupFaceTrackingSession(context: Context) {
        guard ARFaceTrackingConfiguration.isSupported else { print("ARFaceTrackingConfiguration is NOT SUPPORTED!!!"); fatalError() }

        let config = ARFaceTrackingConfiguration()
        config.maximumNumberOfTrackedFaces = 1
        config.isLightEstimationEnabled = true

        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        arView.session.delegate = context.coordinator
    }

    func makeUIView(context: Context) -> ARView {
        setupFaceTrackingSession(context: context)
        context.coordinator.setupFaceAnchor(in: arView)
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: ARSessionDelegate

extension LARFaceTrackingView {
    class Coordinator: NSObject, ARSessionDelegate {
        var parent: LARFaceTrackingView
        var modelManager: LModelManager

        var faceAnchorEntity: AnchorEntity?
//        CreateFaceMask
        var modelEntity: ModelEntity?

        private var updateCounter = 0
        private let updateInterval = 5

        init(_ parent: LARFaceTrackingView) {
            self.parent = parent
            self.modelManager = parent.modelManager
            super.init()
        }
        
        func setupFaceAnchor(in arView: ARView) {
            // 移除现有的 anchor
            if let existingAnchorEntity = faceAnchorEntity {

                MyLog("移除现有的 anchor")
                arView.scene.removeAnchor(existingAnchorEntity)
            }

            faceAnchorEntity = AnchorEntity(.face)

            guard let faceAnchorEntity = faceAnchorEntity else { return }

            arView.scene.addAnchor(faceAnchorEntity)
        }

        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }


//            MyLog("modelManager.isGlobalAutoplayed", modelManager.isGlobalAutoplayed)

            updateCounter += 1
            if updateCounter % updateInterval == 0 {
                updateCounter = 0
                return
            }

//            CreateFaceMask
            if let modelEntity {
                modelEntity.removeFromParent()
            }
//            createFaceMask(from: faceAnchor)

            guard
                !modelManager.isGlobalAutoplayed,
                // Eye Open
                let eyeBlinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft] as? Float,
                let eyeBlinkRight = faceAnchor.blendShapes[.eyeBlinkRight] as? Float,
                // Eyeball Movement
                //            let eyeballMovementLeft = faceAnchor.blendShapes[] as? Float,
                //            let eyeballMovementRight = faceAnchor.blendShapes[] as? Float,
                // Mouth Open
                let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as? Float,
                let jawOpen = faceAnchor.blendShapes[.jawOpen] as? Float,
                let cheekPuff = faceAnchor.blendShapes[.cheekPuff] as? Float
            else {
                return
            }

            // Matrix for translating Face Coordinates to World Coordinates
            let transformMatrix = faceAnchor.transform

            // Calculate pitch, yaw and roll Radians
            let pitch = atan2(transformMatrix.columns.1.z, transformMatrix.columns.2.z)
            let yaw = asin(-transformMatrix.columns.0.z)
            let roll = atan2(transformMatrix.columns.0.y, transformMatrix.columns.0.x)

            //        let newFaceMatrix = SCNMatrix4(faceAnchor.transform)
            //        let faceNode = SCNNode()
            //        faceNode.transform = newFaceMatrix

            // Convert radians to degrees
            // FIXME: pitchDegrees 角度很奇怪,总是有+26度的余量(低头为+,抬头为-)
            let pitchDegrees = pitch * 180 / .pi
            let yawDegrees = yaw * 180 / .pi
            let rollDegrees = roll * 180 / .pi

            // FIXME: pitchDegrees 角度很奇怪,总是有+26度的余量(低头为+,抬头为-)
            //        let pitchDegrees = faceNode.eulerAngles.x * 180 / .pi
            //        let yawDegrees = faceNode.eulerAngles.y * 180 / .pi
            //        let rollDegrees = faceNode.eulerAngles.z * 180 / .pi


//            MyLog("paramAngleX", pitchDegrees)

//            MyLog("paramAngleY", yawDegrees)

//            MyLog("paramAngleZ", rollDegrees)

            // Head Movement
            /// - ParamAngleX: 头部左右转动
            /// - ParamAngleY: 头部上下点头 ( --pitchDegrees )
            /// - ParamAngleZ: 头部倾斜 ( --rollDegrees )
            My_LAppLive2DManager.shared().setModelParam(forID: ParamAngleX, toValue: yawDegrees)
            My_LAppLive2DManager.shared().setModelParam(forID: ParamAngleY, toValue: -(pitchDegrees - 26))
            My_LAppLive2DManager.shared().setModelParam(forID: ParamAngleZ, toValue: -rollDegrees)

            // Eye Open
            My_LAppLive2DManager.shared().setModelParam(forID: ParamEyeLOpen, toValue: 1 - eyeBlinkLeft * 2)
            My_LAppLive2DManager.shared().setModelParam(forID: ParamEyeROpen, toValue: 1 - eyeBlinkRight * 2)

            // Eyeball Movement
            My_LAppLive2DManager.shared().setModelParam(forID: ParamEyeBallX, toValue: faceAnchor.lookAtPoint.x * 2)
            My_LAppLive2DManager.shared().setModelParam(forID: ParamEyeBallY, toValue: faceAnchor.lookAtPoint.y * 2)

            // Mouth Open
            My_LAppLive2DManager.shared().setModelParam(forID: ParamMouthOpenY, toValue: jawOpen * 1.5)
            My_LAppLive2DManager.shared().setModelParam(forID: ParamMouthForm, toValue: 1 - mouthFunnel * 2)

            // Cheek Puff
            My_LAppLive2DManager.shared().setModelParam(forID: ParamCheek, toValue: cheekPuff)


//            MyLog("faceAnchor.geometry.vertices", faceAnchor.geometry.vertices)

//            MyLog("faceAnchor.geometry.triangleCount", faceAnchor.geometry.triangleCount)

//            MyLog("faceAnchor.geometry.triangleIndices", faceAnchor.geometry.triangleIndices)

//            MyLog("faceAnchor.transform", faceAnchor.transform)

//            MyLog("faceAnchor.blendShapes[.eyeBlinkLeft]", faceAnchor.blendShapes[.eyeBlinkLeft] ?? 0)

//            MyLog("faceAnchor.blendShapes[.eyeBlinkRight]", faceAnchor.blendShapes[.eyeBlinkRight] ?? 0)
        }
        
        func session(_ session: ARSession, didFailWithError error: any Error) {
            if error is ARError {

                MyLog("LARFaceTrackingView Session")
                let config = ARFaceTrackingConfiguration()
                config.maximumNumberOfTrackedFaces = 1
                config.isLightEstimationEnabled = true

                session.run(config, options: [.resetTracking, .removeExistingAnchors])
            }
        }
    }
}

// MARK: Create Face Mask

extension LARFaceTrackingView {
    func createFaceMask(from faceAnchor: ARFaceAnchor, in context: Context) {
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
            context.coordinator.modelEntity = ModelEntity(mesh: mesh, materials: [material])

            guard let faceAnchorEntity = context.coordinator.faceAnchorEntity, let modelEntity = context.coordinator.modelEntity else { return }
            modelEntity.position = .init(x: 0, y: 0, z: 0.01)
//            modelEntity.setPosition(.init(x: 0, y: 0, z: 0.1), relativeTo: faceAnchorEntity)
            faceAnchorEntity.addChild(modelEntity)
        } catch {

            MyLog("Error", error)
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

// MARK: LARFaceTrackingView with LARFaceTrackingViewModel
// struct LARFaceTrackingView: UIViewRepresentable {
//    @EnvironmentObject var modelManager: LModelManager
//
//    @StateObject var lARFaceTrackingViewModel: LARFaceTrackingViewModel = .init()
//
//    func makeUIView(context: Context) -> ARView {
//        lARFaceTrackingViewModel.setup(modelManager: modelManager)
//        return lARFaceTrackingViewModel.arView
//    }
//
//    func updateUIView(_ uiView: ARView, context: Context) {}
// }
