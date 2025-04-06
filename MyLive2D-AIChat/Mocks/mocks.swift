//
//  mocks.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

// 创建一个角色的设置
let lmStudioParams = LMStudioParameters(
    model: "deepseek-r1-distill-qwen-1.5b",
    temperature: 0.7,
    maxTokens: -1,
    stream: false
)

let settings = CharacterSettings(
    modelParameters: lmStudioParams,
    voiceParameters: nil  // 暂时不使用语音
)

// 创建一个角色
let character = Character(
    id: UUID(),
    name: "AI助手",
    settings: settings,
    conversations: []
)

// 创建一个对话
let conversation = Conversation(
    id: UUID(),
    characterId: character.id,
    title: "新对话",
    messages: [],
    createdAt: Date(),
    updatedAt: Date()
)

// 添加系统消息
let systemMessage = Message(
    id: UUID(),
    conversationId: conversation.id,
    role: .system,
    content: "Always answer in short.",
    timestamp: Date()
)
