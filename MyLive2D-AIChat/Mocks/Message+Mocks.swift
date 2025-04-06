//
//  Message+Extension.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

// MARK: - 预览用Mock数据
extension Message {
    static let mockMessages: [Message] = [
        .init(id: UUID(),
              conversationId: UUID(),
              role: .user,
              content: "你好",
              timestamp: Date()),
              
        .init(id: UUID(),
              conversationId: UUID(),
              role: .assistant,
              content: "你好！我是AI助手，很高兴见到你。",
              timestamp: Date().addingTimeInterval(1)),
              
        .init(id: UUID(),
              conversationId: UUID(),
              role: .user,
              content: "今天天气怎么样？",
              timestamp: Date().addingTimeInterval(2)),
              
        .init(id: UUID(),
              conversationId: UUID(),
              role: .assistant,
              content: "抱歉，我是AI助手，无法获取实时天气信息。不过我可以帮你回答其他问题！",
              timestamp: Date().addingTimeInterval(3))
    ]
}
