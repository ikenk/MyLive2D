//
//  Message+Extension.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

// MARK: - 预览用Mock数据

extension Message {
    /// 角色1：助手角色
    static var mockMessagesOfAssistantRole: [Message] {
        // MARK: message1
        let message1 = Message(
            id: UUID(),
            conversationId: UUID(),
            role: .user,
            content: "今天天气怎么样？",
            timestamp: Date().addingTimeInterval(-2800)
        )
        
        // MARK: message2
        let message2 = Message(
            id: UUID(),
            conversationId: UUID(),
            role: .assistant,
            content: "我没有实时访问天气数据的能力。建议您查看本地天气应用或网站来获取最新的天气情况。您可以告诉我您的位置，我可以提供一些一般性的季节性建议。",
            timestamp: Date().addingTimeInterval(-2750)
        )
        
        // MARK: message3
        let message3 = Message(
            id: UUID(),
            conversationId: UUID(),
            role: .user,
            content: "我在北京",
            timestamp: Date().addingTimeInterval(-2700)
        )
        
        // MARK: message4
        let message4 = Message(
            id: UUID(),
            conversationId: UUID(),
            role: .assistant,
            content: "北京现在正值春季，春季天气多变，温度逐渐回暖。早晚温差可能较大，建议您查看今天的具体天气预报并适当增减衣物。春季北京有时会有沙尘天气，如果今天有沙尘预警，出门时请戴口罩并减少户外活动。",
            timestamp: Date().addingTimeInterval(-2650)
        )
        
        return [message1, message2, message3, message4]
    }
}
