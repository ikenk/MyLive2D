//
//  ChatService.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/11.
//

import Foundation

enum ChatServiceError: LocalizedError {
    case conversationNotFound

    /// A localized message describing what error occurred.
    var errorDescription: String {
        switch self {
        case .conversationNotFound:
            return "对话不存在，无法发送消息"
        }
    }

    /// A localized message describing the reason for the failure.
    var failureReason: String {
        switch self {
        case .conversationNotFound:
            return "找不到指定ID的对话，请确认对话ID是否正确"
        }
    }

    /// A localized message describing how one might recover from the failure.
    var recoverySuggestion: String {
        switch self {
        case .conversationNotFound:
            return "请尝试创建新的对话或选择现有对话"
        }
    }
}

protocol ChatServiceProtocol {
    func sendMessage(_ message: Message,
                     for character: Character) async throws -> Message
}

class ChatService: ChatServiceProtocol {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager = .default) {
        self.networkManager = networkManager
    }

    func sendMessage(_ message: Message, for character: Character) async throws -> Message {
        // 获取当前对话的历史消息
        guard let conversation = character.conversations.first(where: { $0.id == message.conversationId }) else {
            throw ChatServiceError.conversationNotFound
        }

        var messages: [[String: String]] = []

        // 添加对话历史
        if !conversation.messages.isEmpty {
            // 如果有，则添加历史消息，但需要限制数量以避免超过token限制
            // 通常会取最近的N条消息
            let recentMessages = conversation.messages
                .prefix(10)
                .map { msg -> [String: String] in
                    return ["role": msg.role.rawValue, "content": msg.content]
                }

            messages.append(contentsOf: recentMessages)
        } else {
            // 添加系统提示词
            if let systemPrompt = character.settings.systemPrompt {
                // 如果有
                messages.append(["role": "system", "content": systemPrompt])
            } else {
                // 使用默认系统提示词
                messages.append(["role": "system", "content": "You are a helpful assistant."])
            }
        }

        // 添加当前用户消息
        messages.append(["role": message.role.rawValue, "content": message.content])

        MyLog("messages", messages)

        /// 创建符合LMStudio API格式的请求体（基于OpenAI API规范）
        /// - Parameters:
        ///   - model: 使用的AI模型名称，如"deepseek-r1-distill-qwen-1.5b"
        ///   - messages: 消息数组，包含系统提示和用户输入
        ///     - 每条消息包含role(system/user/assistant)和content(文本内容)
        ///   - temperature: 温度参数(0.0-1.0)，控制输出的随机性，值越高回复越多样
        ///   - max_tokens: 生成文本的最大令牌数，-1表示不限制
        ///   - stream: 是否启用流式输出，true时服务器会逐步返回生成的内容

        struct LMStudioRequest: Encodable {
            let model: String
            let messages: [[String: String]]
            let temperature: Float
            let max_tokens: Int
            let stream: Bool

//            struct Message: Encodable {
//                let role: String
//                let content: String
//            }
        }

        let lmStudioRequest = LMStudioRequest(
            model: character.settings.modelParameters.model,
            messages: messages,
            temperature: character.settings.modelParameters.temperature,
            max_tokens: character.settings.modelParameters.maxTokens,
            // FIXME: 需要修改此处控制strema的代码
            stream: false
        )

        let requestData = try? JSONEncoder().encode(lmStudioRequest)

//        MyLog("requestData", requestData)

        // 准备请求数据
        let request = HTTPRequest(path: "v1/chat/completions", method: .post, headers: ["Content-Type": "application/json"], body: requestData)

        // 创建符合LMStudio API格式的请求
//        let lmStudioRequest = [
//            "model": character.settings.modelParameters.model,
//            "messages": [
//                ["role": "system", "content": "You are a helpful assistant."],
//                ["role": "user", "content": message.content]
//            ],
//            "temperature": character.settings.modelParameters.temperature,
//            "max_tokens": character.settings.modelParameters.maxTokens,
//            "stream": false
//        ] as [String: Any]

//        let request = HTTPRequest(
//            path: "v1/chat/completions", // LMStudio路径
//            method: .post,
//            headers: ["Content-Type": "application/json"],
//            body: try? JSONSerialization.data(withJSONObject: lmStudioRequest)
//        )

        // 发送请求
        let data = try await networkManager.request(request)

        // 解析LMStudio响应
        let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any]
//        MyLog("jsonResponse", jsonResponse ?? [:])
        let choices = jsonResponse?["choices"] as? [[String: Any]]
//        MyLog("choices", choices ?? [])
        let messageData = choices?.first?["message"] as? [String: String]
//        MyLog("messageData", messageData ?? [:])
        let content = messageData?["content"] ?? "无响应内容"

        // 创建新的助手消息
        let assistantMessage = Message(
            id: UUID(),
            conversationId: message.conversationId,
            role: .assistant,
            content: content,
            timestamp: Date(),
            audioUrl: nil
        )

        return assistantMessage
    }
}
