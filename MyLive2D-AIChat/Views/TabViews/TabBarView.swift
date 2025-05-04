//
//  TabView.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/27.
//

import SwiftUI

struct TabBarView: View {
    @State var selectedTabItem: TabItem = .Chat

    var body: some View {
        VStack {
            // 根据选中的标签显示对应的内容
            switch selectedTabItem {
            case .Voice:
                Text("Voice")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case .Chat:
                ChatView(characterId: UUID(uuidString: "123e4567-e89b-12d3-a456-426614174000") ?? UUID(), conversationId: nil)
            case .Camera:
                Text("Camera")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // 自定义底部TabBar
            CustomTabBarView(selectedTabItem: $selectedTabItem)
        }
        .ignoresSafeArea(.keyboard) // 防止键盘弹出时推动TabBar
    }
}

#Preview {
    TabBarView()
}
