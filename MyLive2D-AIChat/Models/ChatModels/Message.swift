//
//  Message.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

/// 表示对话中的单条消息
///
/// 消息是对话的基本组成单位，可以是用户发送的问题，
/// 也可以是AI助手的回复，或者是系统提示。
///
/// 每条消息都包含内容、角色信息和时间戳，以及可选的音频URL。
struct Message: Codable {
    // MARK: - 属性
    
    /// 消息的唯一标识符
    let id: UUID
    
    /// 关联的对话ID
    /// 标识该消息属于哪个对话
    let conversationId: UUID
    
    /// 消息的角色
    /// 指明消息是来自系统、用户还是助手
    let role: MessageRole
    
    /// 消息的文本内容
    let content: String
    
    /// 消息的创建时间
    let timestamp: Date
    
    /// 关联的音频文件URL
    /// 当消息有对应的语音时使用，例如AI回复的语音
    var audioUrl: URL?
}
