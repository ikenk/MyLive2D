//
//  LMTKView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/19.
//

import MetalKit
import SwiftUI

struct LMTKView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
                
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
    }
}

