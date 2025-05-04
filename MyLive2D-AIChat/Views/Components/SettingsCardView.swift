//
//  SettingCard.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/05/02.
//

import SwiftUI

extension View {
    // 通用的设置卡片视图
    @ViewBuilder
    func settingsCard<Content: View>(title: String, alignment:HorizontalAlignment = .leading, @ViewBuilder content: ()->Content)->some View {
        VStack(alignment: alignment, spacing: 16) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.primary)

            content()
        }
        .padding(20)
        .backgroundShadow(cornerRadius: 30, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 4))
    }
}
