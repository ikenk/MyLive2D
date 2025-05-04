//
//  Character.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//

import Foundation

/// 表示AI聊天系统中的角色实体
///
/// 角色是系统中的主要实体，包含基本信息、设置和对话历史。
/// 每个角色可以拥有多个对话，并具有特定的设置参数。
///
/// - Note: 角色ID可以与Live2D角色的ID对应，便于整合两个系统
struct Character: Codable {
    // MARK: - 属性
    
    /// 角色的唯一标识符
    /// 用于区分不同的角色，同时可对应Live2D角色的ID
    let id: UUID
    
    /// 角色的名称
    /// 可对应Live2D角色的名称
    let name: String
    
    /// 角色的设置参数
    /// 包含模型参数、语音参数等配置
    var settings: CharacterSettings
    
    /// 该角色的所有对话记录
    /// 按时间顺序存储的对话列表
    var conversations: [Conversation]
}
