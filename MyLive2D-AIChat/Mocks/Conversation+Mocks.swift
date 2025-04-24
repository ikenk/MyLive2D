//
//  Conversation.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/24.
//

import Foundation

extension Conversation {
    /// 角色1：助手角色
    static var conversationsOfAssistantRole: [Conversation] {
        // MARK: conversation1

        let conversation1 = Conversation(
            id: UUID(),
            characterId: UUID(),
            title: "初次对话",
            messages: [
                Message(
                    id: UUID(),
                    conversationId: UUID(),
                    role: .user,
                    content: "你好!",
                    timestamp: Date().addingTimeInterval(-3600)
                ),
                Message(
                    id: UUID(),
                    conversationId: UUID(),
                    role: .assistant,
                    content: "你好！我是AI助手，很高兴为你服务。有什么我可以帮助你的吗？",
                    timestamp: Date().addingTimeInterval(-3550)
                )
            ],
            createdAt: Date().addingTimeInterval(-3600),
            updatedAt: Date().addingTimeInterval(-3550)
        )

        // MARK: conversation2

        let conversation2 = Conversation(
            id: UUID(),
            characterId: UUID(),
            title: "天气咨询",
            messages: [
                Message(
                    id: UUID(),
                    conversationId: UUID(),
                    role: .user,
                    content: "今天天气怎么样？",
                    timestamp: Date().addingTimeInterval(-2800)
                ),
                Message(
                    id: UUID(),
                    conversationId: UUID(),
                    role: .assistant,
                    content: "我没有实时访问天气数据的能力。建议您查看本地天气应用或网站来获取最新的天气情况。您可以告诉我您的位置，我可以提供一些一般性的季节性建议。",
                    timestamp: Date().addingTimeInterval(-2750)
                ),
                Message(
                    id: UUID(),
                    conversationId: UUID(),
                    role: .user,
                    content: "我在北京",
                    timestamp: Date().addingTimeInterval(-2700)
                ),
                Message(
                    id: UUID(),
                    conversationId: UUID(),
                    role: .assistant,
                    content: "北京现在正值春季，春季天气多变，温度逐渐回暖。早晚温差可能较大，建议您查看今天的具体天气预报并适当增减衣物。春季北京有时会有沙尘天气，如果今天有沙尘预警，出门时请戴口罩并减少户外活动。",
                    timestamp: Date().addingTimeInterval(-2650)
                )
            ],
            createdAt: Date().addingTimeInterval(-2800),
            updatedAt: Date().addingTimeInterval(-2650)
        )

        // MARK: conversation3

        let conversation3 = Conversation(
            id: UUID(),
            characterId: UUID(),
            title: "电影推荐",
            messages: [
                Message(
                    id: UUID(),
                    conversationId: UUID(),
                    role: .user,
                    content: "你能推荐一些好看的科幻电影吗？",
                    timestamp: Date().addingTimeInterval(-1200)
                ),
                Message(
                    id: UUID(),
                    conversationId: UUID(),
                    role: .assistant,
                    content: "当然可以！以下是一些广受好评的科幻电影：\n\n1. 《星际穿越》- 探索时间相对论和五维空间的壮观之作\n2. 《银翼杀手2049》- 关于人工智能和身份的深度探索\n3. 《到达之际》- 语言学家与外星生物的沟通尝试\n4. 《黑客帝国》系列 - 虚拟现实与哲学思考的经典\n5. 《2001太空漫游》- 库布里克的视觉杰作\n6. 《头号玩家》- 虚拟现实游戏世界的冒险\n7. 《异形》系列 - 太空恐怖的代表作\n8. 《Her》- 关于AI与人类情感关系的思考\n9. 《月球》- 低成本高概念的孤独月球基地故事\n10. 《降临》- 非线性思维与外星接触\n\n这些电影涵盖了科幻片的不同风格和主题，从硬科幻到更具哲学色彩的作品都有。您对哪种类型的科幻片更感兴趣？",
                    timestamp: Date().addingTimeInterval(-1150)
                )
            ],
            createdAt: Date().addingTimeInterval(-1200),
            updatedAt: Date().addingTimeInterval(-1150)
        )

        return [conversation1, conversation2, conversation3]
    }
}
