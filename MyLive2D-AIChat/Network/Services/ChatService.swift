//
//  ChatService.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/11.
//

import Foundation

protocol ChatServiceProtocol {
    func sendMessage(_ message: Message,
                     for character: Character) async throws -> Message
}

class ChatService: ChatServiceProtocol {
    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func sendMessage(_ message: Message, for character: Character) async throws -> Message {
        /**
         OpenAI API通信格式
         {
           "model": "模型名称",
           "messages": [
             {"role": "system", "content": "你是一个有用的助手。"},
             {"role": "user", "content": "你好！"},
             {"role": "assistant", "content": "你好！有什么我可以帮助你的吗？"},
             {"role": "user", "content": "请解释量子计算。"}
           ],
           "temperature": 0.7,
           "max_tokens": 800,
           "stream": false
         }
         */
        // API请求模型
        struct ChatRequestBody: Encodable {
            let content: String
            let characterId: String
            let modelParameters: LMStudioParameters
        }

        struct ChatResponse: Decodable {
            let message: String
            let characterId: String
        }

        // 准备请求数据
        let requestBody = ChatRequestBody(content: message.content, characterId: character.id.uuidString, modelParameters: character.settings.modelParameters)

        let request = try HTTPRequest(path: "v1/chat/completions", method: .post, headers: ["Content-Type": "application/json"], body: JSONEncoder().encode(requestBody))

        let response: ChatResponse = try await networkManager.request<ChatResponse>(request)

        // 创建新的助手消息
        let assistantMessage = Message(id: UUID(), conversationId: message.conversationId, role: .assistant, content: response.message, timestamp: Date(), audioUrl: nil)

        return assistantMessage
    }
}
