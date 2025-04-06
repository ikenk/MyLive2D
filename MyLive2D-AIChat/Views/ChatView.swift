//
//  ChatView.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//

import SwiftUI

// MARK: - 聊天视图
struct ChatView: View {
    
    var body: some View {
        Text("Hello World")
    }
}

// MARK: - 消息气泡
struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
            }
            
            Text(message.content)
                .padding()
                .background(message.role == .user ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.role == .user ? .white : .primary)
                .cornerRadius(15)
                .padding(.horizontal)
            
            if message.role == .assistant {
                Spacer()
            }
        }
    }
}

#Preview {
    ChatView()
}
