//
//  SettingsView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/29.
//

import SwiftUI

struct SettingsView: View {
    @State private var modelParameter:ModelParameter = .init()
    var body: some View {
        VStack(alignment:.leading, spacing:3){
            Slider(value: $modelParameter.xTranslation)
        }
    }
}

#Preview {
    SettingsView()
}

struct ModelParameter {
    var xTranslation:Float = .zero
    var yTranslation:Float = .zero
    var scale:Float = .zero
    var rotation:Float = .zero
}
