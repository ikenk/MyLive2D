//
//  Message.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

struct Message: Codable {
    let id: UUID           // 消息唯一标识符
    let conversationId: UUID  // 关联的对话ID
    let role: MessageRole  // 消息角色(system/user/assistant)
    let content: String    // 消息内容
    let timestamp: Date    // 消息时间戳
    var audioUrl: URL?     // 预留的语音URL字段
}
