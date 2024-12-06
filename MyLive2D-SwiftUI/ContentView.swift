//
//  ContentView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/17.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @State private var sceneIndex:Int = 0
    var body: some View {
        Text("Hello World!!!")
            .font(.largeTitle)
        
        Button {
//            My_LAppLive2DManager.shared().changeScene(1)
            My_LAppLive2DManager.shared().nextScene()
        } label: {
            Text("Tap it!!!")
                .font(.title2)
                .foregroundStyle(.red)
        }
        
        Button {
            My_LAppLive2DManager.shared().setModelParamter(0.1, forID: "ParamEyeLOpen")
        } label: {
            Text("Set L/R Eye Status")
                .font(.title2)
                .foregroundStyle(.yellow)
        }
    }
}


//#Preview {
//    ContentView()
//}
