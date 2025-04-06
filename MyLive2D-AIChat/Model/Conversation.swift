//
//  Conversation.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

struct Conversation: Codable {
    let id: UUID           // 对话唯一标识符
    let characterId: UUID  // 关联的角色ID
    let title: String      // 对话标题
    var messages: [Message]  // 对话消息列表
    let createdAt: Date    // 创建时间
    let updatedAt: Date    // 更新时间
}
