//
//  ContentView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/17.
//

import PhotosUI
import RealityKit
import SwiftUI

struct LConfigurationView: View {
    @EnvironmentObject var modelManager: LModelManager

    @EnvironmentObject var viewManager: LViewManager

//    @State private var sceneIndex: Int = 0

//    @State private var modelParameter: ModelParameter = .init()

    var body: some View {
        List {
            LChangeModelView()
                .listRowBackground(Color.clear)

            LAnimationControllerView()
                .listRowBackground(Color.clear)

            LPickImageView()
                .listRowBackground(Color.clear)

            LSliderView()
                .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
    }
}
