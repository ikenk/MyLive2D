//
//  LMTKView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/19.
//

import MetalKit
import SwiftUI

struct LMTKView: UIViewRepresentable {
    
    init(){
        
    }
    
    func getModelPath() -> String{
        
        let jsonFile = "Frieren.model3"
        
        guard let jsonPath = Bundle.main.path(forResource: jsonFile, ofType: "json") else {
            print("Failed to find model json file")
            return ""
        }
        
        return jsonPath
    }
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        
        let modelPath = getModelPath()
        
        // 创建渲染器
        guard let renderer = Live2DRenderer(metalKitView: mtkView, modelPath: modelPath) else {
            fatalError("Failed to create Live2D renderer")
        }
                
        // 设置delegate
        mtkView.delegate = renderer
                
        // 保持renderer的引用
        context.coordinator.renderer = renderer
                
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var renderer: Live2DRenderer?
    }
}

