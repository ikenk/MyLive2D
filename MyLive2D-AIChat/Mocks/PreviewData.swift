//
//  PreviewData.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/24.
//

import Foundation

enum PreviewData {
    // MARK: 模拟角色列表

    static var mockCharacters: [Character] {
        Character.mockCharacters
    }

    // MARK: 模拟角色1(助手角色)对话列表

    static var mockConversationsOfAssistantRole: [Conversation] {
        Conversation.conversationsOfAssistantRole
    }

    // MARK: 模拟角色1(助手角色)消息列表

    static var mockMessagesOfAssistantRole: [Message] {
        Message.mockMessagesOfAssistantRole
    }
}
