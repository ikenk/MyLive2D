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
    
    init?(metalKitView: MTKView, modelPath: String) {
        guard let device = metalKitView.device else { return nil }
        guard let queue = device.makeCommandQueue() else { return nil }
        
        self.device = device
        self.commandQueue = queue
        
        // 设置MTKView的渲染属性
        metalKitView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        metalKitView.framebufferOnly = false
        metalKitView.drawableSize = metalKitView.bounds.size
        
        super.init()
    }
    
    // MARK: - MTKViewDelegate
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    }
    
    func draw(in view: MTKView) {
    }
}
