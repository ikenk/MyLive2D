//
//  Conversation.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

/// 表示用户与角色之间的一次完整对话
///
/// 对话由多条消息组成，属于特定角色，有自己的标题和时间信息。
/// 对话可以被创建、更新和删除。
struct Conversation: Codable {
    // MARK: - 属性
    
    /// 对话的唯一标识符
    let id: UUID
    
    /// 关联的角色ID
    /// 指明这个对话属于哪个角色
    let characterId: UUID
    
    /// 对话的标题
    /// 用户可编辑，用于快速识别对话内容
    let title: String
    
    /// 对话中的消息列表
    /// 按时间顺序存储的消息
    var messages: [Message]
    
    /// 对话创建的时间
    let createdAt: Date
    
    /// 对话最后更新的时间
    /// 当添加新消息时会更新此时间
    var updatedAt: Date
}
