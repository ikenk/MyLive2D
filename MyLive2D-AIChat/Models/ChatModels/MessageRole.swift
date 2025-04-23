//
//  MessageRole.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

enum MessageRole: String, Codable {
    case system     // 系统消息，如设置角色人设
    case user       // 用户消息
    case assistant  // AI助手回复
}
