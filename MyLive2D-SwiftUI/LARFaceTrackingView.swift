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
    @StateObject var lARFaceTrackingViewModel:LARFaceTrackingViewModel = .init()
    
    func makeUIView(context: Context) -> ARView {
        lARFaceTrackingViewModel.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
    }
    
}
