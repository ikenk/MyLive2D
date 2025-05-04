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
    
    @State private var isPlayBtnActive: Bool = true
    @State private var isARBtnActive: Bool = true
    
    var body: some View {
//        Section {
//            Toggle(isOn: $modelManager.isGlobalAutoplayed) {
//                Text("Auto-Animate Toggle")
//                    .font(.title2)
//                    .padding(.leading,10)
//            }
//            .padding(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .strokeBorder(.purple, lineWidth: 1)
//            )
//            .padding(.horizontal, 10)
//            .onChange(of: modelManager.isGlobalAutoplayed) { newValue in
//                My_LAppLive2DManager.shared().setModelMotionGlobalAutoplayed(newValue)
//            }
//
//            Toggle(isOn: $viewManager.isShowLARFaceTrackingView) {
//                Text("FaceTracking View Toggle")
//                    .font(.title2)
//                    .padding(.leading,10)
//            }
//            .padding(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .strokeBorder(.purple, lineWidth: 1)
//            )
//            .padding(.horizontal, 10)
//        } header: {
//            Text("Animation")
//        }
        
        HStack {
            Button {
                withAnimation(.spring()) {
                    isPlayBtnActive.toggle()
                }
                modelManager.isGlobalAutoplayed = isPlayBtnActive
                print("modelManager.isGlobalAutoplayed:\(modelManager.isGlobalAutoplayed)")
            } label: {
                Image(systemName: "play")
                    .font(.system(size: 37))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .foregroundStyle(isPlayBtnActive ? .blue : .primary)
            .padding()
            .background(isPlayBtnActive ? .gray.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 3))
            .onChange(of: modelManager.isGlobalAutoplayed) { newValue in
                My_LAppLive2DManager.shared().setModelMotionGlobalAutoplayed(newValue)
            }
            
            Button {
                withAnimation(.spring()) {
                    isARBtnActive.toggle()
                }
                withAnimation(.spring()) {
                    viewManager.isShowLARFaceTrackingView = isARBtnActive
                }
            } label: {
                Image(systemName: "person.and.background.dotted")
                    .font(.system(size: 37))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .foregroundStyle(isARBtnActive ? .green : .primary)
            .padding()
            .background(isARBtnActive ? .gray.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 3))
        }
    }
}
