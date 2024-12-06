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
    
    @State private var isAutoplayed:Bool = true
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
            
        } label: {
            Text("Set L/R Eye Status")
                .font(.title2)
                .foregroundStyle(.yellow)
        }
        
        Toggle("Model Is Autoplayed", isOn: $isAutoplayed)
            .padding(.horizontal, 10)
            .foregroundStyle(.indigo)
            .border(.purple)
            .onChange(of: isAutoplayed) { newValue in
                My_LAppLive2DManager.shared().setModelMotionIfAutoplay(newValue)
            }
    }
}


//#Preview {
//    ContentView()
//}
