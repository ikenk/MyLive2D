//
//  ContentView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/17.
//

import RealityKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelManager: ModelManager

    @State private var sceneIndex: Int = 0

    @State private var modelParameter: ModelParameter = .init()

    var body: some View {
        ScrollView(.vertical) {
            Text("Hello!!!")
                .font(.largeTitle)

            Button {
                My_LAppLive2DManager.shared().nextScene()
            } label: {
                Text("Next Model")
                    .font(.title2)
                    .foregroundStyle(.red)
            }

            Toggle("Model Is Autoplayed", isOn: $modelManager.isGlobalAutoplayed)
                .padding(10)
                .foregroundStyle(.indigo)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.purple, lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .onChange(of: modelManager.isGlobalAutoplayed) { newValue in
                    My_LAppLive2DManager.shared().setModelMotionGlobalAutoplayed(newValue)
                }
            Group {
                Slider(value: $modelParameter.xTranslation, in: -Float(UIScreen.main.bounds.width) / 2 ... Float(UIScreen.main.bounds.width) / 2) {
                    Text("X Translation")
                        .foregroundStyle(.yellow)
                }
                Slider(value: $modelParameter.yTranslation, in: -Float(UIScreen.main.bounds.height) / 2 ... Float(UIScreen.main.bounds.height) / 2) {
                    Text("Y Translation")
                        .foregroundStyle(.yellow)
                }
                Slider(value: $modelParameter.scale, in: 1 ... 10) {
                    Text("Scale")
                        .foregroundStyle(.yellow)
                }
            }
            .padding()
        }
    }
}

// #Preview {
//    ContentView()
// }

struct ModelParameter {
    var xTranslation: Float = .zero
    var yTranslation: Float = .zero
    var scale: Float = .zero
    var rotation: Float = .zero
}
