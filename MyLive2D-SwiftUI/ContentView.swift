//
//  ContentView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/17.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    var body: some View {
        Text("Hello World!!!")
            .font(.largeTitle)
        
        Button {
            print("Button")
        } label: {
            Text("Tap it!!!")
                .font(.title2)
                .foregroundStyle(.red)
        }
    }
}


//#Preview {
//    ContentView()
//}
