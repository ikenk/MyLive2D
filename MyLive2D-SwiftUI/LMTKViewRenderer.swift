//
//  LMTKViewModel.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/19.
//

import Foundation
import Metal
import MetalKit

class Live2DRenderer: NSObject, MTKViewDelegate {
    private var device: MTLDevice
    private var commandQueue: MTLCommandQueue
    private let model: Live2DModelMetal
    private var viewportSize: vector_uint2 = .init(0, 0)
    
    
    init?(metalKitView: MTKView, modelPath: String) {
        guard let device = metalKitView.device else { return nil }
        guard let queue = device.makeCommandQueue() else { return nil }
        
        self.device = device
        self.commandQueue = queue
        // 初始化Live2D模型
        self.model = Live2DModelMetal(jsonPath: modelPath)
        
        // 设置MTKView的渲染属性
        metalKitView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        metalKitView.framebufferOnly = false
        metalKitView.drawableSize = metalKitView.bounds.size
        
        super.init()
        
        // 加载纹理
        loadTextures(device: device)
        
        // 设置premultiplied alpha
        model.setPremultipliedAlpha(true)
    }
    
    private func loadTextures(device: MTLDevice) {
        let textureLoader = MTKTextureLoader(device: device)
        
        for i in 0 ..< model.getNumberOfTextures() {
            let textureName = model.getFileName(ofTexture: i)
            if let textureURL = Bundle.main.url(forResource: textureName, withExtension: nil),
               let texture = try? textureLoader.newTexture(URL: textureURL, options: nil)
            {
                model.setTexture(UInt32(i), to: texture)
            }
        }
    }
    
    // MARK: - MTKViewDelegate
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        viewportSize.x = UInt32(size.width)
        viewportSize.y = UInt32(size.height)
        
        // 更新模型视图投影矩阵
        let scale = Float(size.width) / model.getCanvasWidth()
        let matrix = matrix_float4x4(
            [scale, 0, 0, 0],
            [0, -scale, 0, 0],
            [0, 0, 1, 0],
            [0, 0, 0, 1]
        )
        model.setMatrix(matrix)
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderPassDescriptor = view.currentRenderPassDescriptor,
              let drawable = view.currentDrawable else { return }
        
        // 更新模型
        model.update()
        model.updatePhysics(1.0 / 60.0) // 假设60fps
        
        // 创建渲染命令编码器
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        // 绘制模型
        model.draw()
        
        renderEncoder.endEncoding()
        
        // 显示绘制结果
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
