//
//  LAnimationControllerView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/18.
//

import SwiftUI

struct LAnimationControllerView: View {
    @EnvironmentObject var modelManager: LModelManager
    @EnvironmentObject var viewManager: LViewManager

    var body: some View {
        Section {
            Toggle(isOn: $modelManager.isGlobalAutoplayed) {
                Text("Auto-Animate Toggle")
                    .font(.title2)
                    .padding(.leading, 10)
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.purple, lineWidth: 1)
            )
            .padding(.horizontal, 10)
            .onChange(of: modelManager.isGlobalAutoplayed) { newValue in
                My_LAppLive2DManager.shared().setModelMotionGlobalAutoplayed(newValue)
            }

            Toggle(isOn: $viewManager.isShowLARFaceTrackingView) {
                Text("FaceTracking View Toggle")
                    .font(.title2)
                    .padding(.leading, 10)
            }
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.purple, lineWidth: 1)
            )
            .padding(.horizontal, 10)
        } header: {
            Text("Animation")
        }
    }
}
