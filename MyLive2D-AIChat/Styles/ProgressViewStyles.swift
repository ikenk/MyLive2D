//
//  ProgressViewStyles.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/05/03.
//

import SwiftUI

struct DarkModeProgressViewStyle:ProgressViewStyle{
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .tint(Color.init(uiColor: .systemBackground))
    }
}
