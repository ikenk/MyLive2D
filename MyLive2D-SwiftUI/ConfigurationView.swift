//
//  ContentView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/17.
//

import RealityKit
import SwiftUI

struct ConfigurationView: View {
    @EnvironmentObject var modelManager: ModelManager

    @State private var sceneIndex: Int = 0

    @State private var modelParameter: ModelParameter = .init()

    var body: some View {
        ScrollView(.vertical) {
            Text("Configuration Panel")
                .font(.title)

            Button {
                My_LAppLive2DManager.shared().nextScene()
            } label: {
                Text("Next Model")
                    .font(.title2)
                    .foregroundStyle(.indigo)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.purple, lineWidth: 1)
            )
            .padding(.horizontal, 10)

            Button {
                My_LAppLive2DManager.shared().previousScene()
            } label: {
                Text("Previous Model")
                    .font(.title2)
                    .foregroundStyle(.indigo)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.purple, lineWidth: 1)
            )
            .padding(.horizontal, 10)

            Toggle("Anime Autoplayed Switch", isOn: $modelManager.isGlobalAutoplayed)
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
                Slider(value: $modelParameter.xTranslation, in: -Float(UIScreen.main.bounds.width) / Float(UIScreen.main.bounds.height) ... Float(UIScreen.main.bounds.width) / Float(UIScreen.main.bounds.height)) {
                    Text("X Translation")
                        .foregroundStyle(.primary)
                } minimumValueLabel: {
                    Text("\((-Float(UIScreen.main.bounds.width) / 2).formatted(.number.precision(.fractionLength(0))))")
                        .font(.callout)
                } maximumValueLabel: {
                    Text("\((Float(UIScreen.main.bounds.width) / 2).formatted(.number.precision(.fractionLength(0))))")
                        .font(.callout)
                }
                .onChange(of: modelParameter.xTranslation) { newValue in
                    print("[MyLog]modelParameter.xTranslation: \(newValue)")
                    My_LAppLive2DManager.shared().setModelPositionOnX(newValue)
                }

                Slider(value: $modelParameter.yTranslation, in: -1 ... 1) {
                    Text("Y Translation")
                        .foregroundStyle(.primary)
                } minimumValueLabel: {
                    Text("\((-Float(UIScreen.main.bounds.height) / 2).formatted(.number.precision(.fractionLength(0))))")
                        .font(.callout)
                } maximumValueLabel: {
                    Text("\((Float(UIScreen.main.bounds.height) / 2).formatted(.number.precision(.fractionLength(0))))")
                        .font(.callout)
                }
                .onChange(of: modelParameter.yTranslation) { newValue in
                    print("[MyLog]modelParameter.yTranslation: \(newValue)")
                    My_LAppLive2DManager.shared().setModelPositionOnY(newValue)
                }

                Slider(value: $modelParameter.scale, in: 1 ... 3) {
                    Text("Scale")
                        .foregroundStyle(.primary)
                } minimumValueLabel: {
                    Text("1")
                        .font(.callout)
                } maximumValueLabel: {
                    Text("2")
                        .font(.callout)
                }
                .onChange(of: modelParameter.scale) { newValue in
                    print("[MyLog]modelParameter.scale: \(newValue)")
                    My_LAppLive2DManager.shared().setModelScale(x: newValue, y: newValue)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.purple, lineWidth: 1)
            )
            .padding(.horizontal, 10)
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
