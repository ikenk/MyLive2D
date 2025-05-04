//
//  MessageRole.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

/// 定义消息的角色类型
///
/// 在聊天系统中，消息可以来自不同的角色，
/// 包括系统消息、用户输入和AI助手的回复。
///
/// 角色类型影响消息的显示方式和处理逻辑。
enum MessageRole: String, Codable {
    // MARK: - 枚举值
    
    /// 系统消息
    /// 通常用于设置提示词或上下文信息，不显示给用户
    case system
    
    /// 用户消息
    /// 表示用户输入的内容
    case user
    
    /// AI助手回复
    /// 表示AI模型生成的回复内容
    case assistant
}
