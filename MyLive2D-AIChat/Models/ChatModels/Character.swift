//
//  Character.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//

import Foundation

struct Character: Codable {
    let id: UUID            // 角色唯一标识符，用于区分不同的角色 对应Live2D角色的ID
    let name: String        // 角色名称 对应Live2D角色的名称
    var settings: CharacterSettings  // 角色的设置参数
    var conversations: [Conversation]  // 该角色的所有对话记录
}
