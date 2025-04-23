//
//  Character+Mocks.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/23.
//

import Foundation

/// MARK: - 模拟角色数据
extension Character {
    static var mockCharacters: [Character] {
        let character1 = Character(
            id: UUID(),
            name: "助手角色",
            settings: CharacterSettings(
                modelParameters: LMStudioParameters(
                    model: "deepseek-r1-distill-qwen-1.5b",
                    temperature: 0.7,
                    maxTokens: -1,
                    stream: false
                ),
                voiceParameters: nil
            ),
            conversations: [
                Conversation(
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
            ]
        )
        
        // 角色2：医疗顾问
        let character2 = Character(
            id: UUID(),
            name: "医疗顾问",
            settings: CharacterSettings(
                modelParameters: LMStudioParameters(
                    model: "mistral-7b-instruct",
                    temperature: 0.5,
                    maxTokens: 2048,
                    stream: true
                ),
                voiceParameters: nil
            ),
            conversations: [
                Conversation(
                    id: UUID(),
                    characterId: UUID(),
                    title: "健康咨询",
                    messages: [
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .system,
                            content: "作为一个医疗顾问AI，你提供基本的健康信息，但总是建议用户咨询专业医生获取诊断和治疗建议。",
                            timestamp: Date().addingTimeInterval(-7200)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "我最近总是感到疲劳，这可能是什么原因？",
                            timestamp: Date().addingTimeInterval(-7100)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "疲劳可能由多种因素引起，包括睡眠不足、压力过大、饮食不均衡、缺乏运动或某些医疗状况。建议你保持规律作息，均衡饮食，适当运动，如症状持续，请咨询医生进行专业评估。",
                            timestamp: Date().addingTimeInterval(-7050)
                        )
                    ],
                    createdAt: Date().addingTimeInterval(-7200),
                    updatedAt: Date().addingTimeInterval(-7050)
                )
            ]
        )
        
        // 角色3：编程教练
        let character3 = Character(
            id: UUID(),
            name: "编程教练",
            settings: CharacterSettings(
                modelParameters: LMStudioParameters(
                    model: "codellama-7b",
                    temperature: 0.3,
                    maxTokens: 4096,
                    stream: false
                ),
                voiceParameters: nil
            ),
            conversations: [
                Conversation(
                    id: UUID(),
                    characterId: UUID(),
                    title: "Swift学习",
                    messages: [
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "SwiftUI中的@State和@Binding有什么区别？",
                            timestamp: Date().addingTimeInterval(-10800)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "@State是用于在视图内部管理的私有状态。当@State变量改变时，视图会重新渲染。\n\n@Binding是一个对其他视图中状态的引用。它允许子视图读取和修改父视图中的状态。使用@Binding，您可以在不同视图间共享和修改状态。\n\n简单来说：@State是数据所有者，@Binding是数据引用。",
                            timestamp: Date().addingTimeInterval(-10750)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "能给我展示一个简单的例子吗？",
                            timestamp: Date().addingTimeInterval(-10700)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "```swift\n// 父视图\nstruct ParentView: View {\n    @State private var counter = 0\n    \n    var body: some View {\n        VStack {\n            Text(\"计数: \\(counter)\")\n            ChildView(counter: $counter)\n        }\n    }\n}\n\n// 子视图\nstruct ChildView: View {\n    @Binding var counter: Int\n    \n    var body: some View {\n        Button(\"增加\") {\n            counter += 1  // 修改父视图的状态\n        }\n    }\n}\n```\n\n在这个例子中，ParentView拥有counter状态(@State)，而ChildView通过@Binding引用这个状态。当ChildView中的按钮被点击时，它可以修改父视图中的counter，父视图会相应地更新。",
                            timestamp: Date().addingTimeInterval(-10650)
                        )
                    ],
                    createdAt: Date().addingTimeInterval(-10800),
                    updatedAt: Date().addingTimeInterval(-10650)
                ),
                Conversation(
                    id: UUID(),
                    characterId: UUID(),
                    title: "算法问题",
                    messages: [
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "如何实现快速排序算法？",
                            timestamp: Date().addingTimeInterval(-5400)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "快速排序是一种高效的排序算法，基于分治策略。以下是Swift实现：\n\n```swift\nfunc quickSort<T: Comparable>(_ array: [T]) -> [T] {\n    if array.count <= 1 {\n        return array\n    }\n    \n    let pivot = array[array.count / 2]\n    let less = array.filter { $0 < pivot }\n    let equal = array.filter { $0 == pivot }\n    let greater = array.filter { $0 > pivot }\n    \n    return quickSort(less) + equal + quickSort(greater)\n}\n```\n\n这个实现选择数组中间元素作为基准，然后将数组分为三部分：小于基准、等于基准和大于基准的元素。然后递归地对小于和大于基准的部分进行排序。",
                            timestamp: Date().addingTimeInterval(-5350)
                        )
                    ],
                    createdAt: Date().addingTimeInterval(-5400),
                    updatedAt: Date().addingTimeInterval(-5350)
                )
            ]
        )
        
        // 角色4：旅行顾问
        let character4 = Character(
            id: UUID(),
            name: "旅行顾问",
            settings: CharacterSettings(
                modelParameters: LMStudioParameters(
                    model: "llama-2-13b-chat",
                    temperature: 0.8,
                    maxTokens: 2048,
                    stream: true
                ),
                voiceParameters: nil
            ),
            conversations: [
                Conversation(
                    id: UUID(),
                    characterId: UUID(),
                    title: "日本旅行规划",
                    messages: [
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "我计划去日本旅行一周，有什么建议？",
                            timestamp: Date().addingTimeInterval(-86400)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "日本一周的行程非常紧凑，建议专注于一两个区域。以下是一个东京+京都的行程建议：\n\n东京(4天)：\n- 第1天：浅草寺、东京晴空塔、上野公园\n- 第2天：明治神宫、原宿、涩谷\n- 第3天：秋叶原、银座、东京塔\n- 第4天：迪士尼乐园或迪士尼海洋\n\n京都(3天)：\n- 第5天：伏见稻荷大社、清水寺\n- 第6天：金阁寺、银阁寺、哲学之道\n- 第7天：岚山竹林、二条城\n\n交通：建议购买JR Pass，涵盖东京至京都的新干线。\n住宿：东京可住新宿或银座，京都推荐住祗园附近。\n饮食：一定要尝试拉面、寿司、天妇罗和和牛。\n购物：东京的秋叶原(电子产品)、京都的锦市场(传统工艺品)。",
                            timestamp: Date().addingTimeInterval(-86350)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "日本旅行大概需要多少预算？",
                            timestamp: Date().addingTimeInterval(-86300)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "日本一周旅行的预算大致如下(单人计)：\n\n1. 机票：往返约700-1500美元(取决于季节和出发地)\n2. 住宿：\n   - 经济型：50-80美元/晚\n   - 中档酒店：100-200美元/晚\n   - 高级酒店：200美元以上/晚\n3. JR Pass(7天全国通票)：约280美元\n4. 市内交通：每天约10-15美元\n5. 餐饮：\n   - 简餐：5-15美元/餐\n   - 普通餐厅：15-30美元/餐\n   - 高级餐厅：50美元以上/餐\n6. 景点门票：每天约20-40美元\n7. 购物和杂项：视个人情况而定\n\n总计：一周约1500-3000美元(不含大额购物)\n\n贴士：春(樱花季)和秋(红叶季)是旅游旺季，价格会更高。提前3-6个月预订可获得更好价格。",
                            timestamp: Date().addingTimeInterval(-86250)
                        )
                    ],
                    createdAt: Date().addingTimeInterval(-86400),
                    updatedAt: Date().addingTimeInterval(-86250)
                )
            ]
        )
        
        // 角色5：历史学者
        let character5 = Character(
            id: UUID(),
            name: "历史学者",
            settings: CharacterSettings(
                modelParameters: LMStudioParameters(
                    model: "vicuna-33b",
                    temperature: 0.6,
                    maxTokens: 3072,
                    stream: true
                ),
                voiceParameters: nil
            ),
            conversations: [
                Conversation(
                    id: UUID(),
                    characterId: UUID(),
                    title: "古埃及文明",
                    messages: [
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .system,
                            content: "你是一位专精古代历史的学者，特别擅长埃及、希腊和罗马文明。提供准确、深入且引人入胜的历史知识。",
                            timestamp: Date().addingTimeInterval(-172800)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "金字塔是如何建造的？",
                            timestamp: Date().addingTimeInterval(-172750)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "古埃及金字塔的建造是一项令人惊叹的工程壮举，特别是考虑到它们建于4500年前。以下是建造过程的主要步骤：\n\n1. **规划阶段**：埃及人使用绳索、木桩和精确的天文观测确定金字塔的方向和基础。大金字塔的四个角几乎完美地指向四个基本方向。\n\n2. **石材获取**：石灰石主要从附近的采石场开采，而花岗岩则从阿斯旺运输(距离超过800公里)。工人使用铜凿和石锤开采石块。\n\n3. **石材运输**：\n   - 当地石材通过滑橇拖运\n   - 远距离石材沿尼罗河用船运输\n   - 从河岸到建筑工地可能使用木制滚轮或湿润的泥地作为滑道\n\n4. **提升石块**：考古学家提出了几种理论：\n   - 斜坡理论：建造逐渐升高的外部斜坡\n   - 螺旋坡道理论：围绕金字塔的螺旋形坡道\n   - 内部斜坡理论：使用金字塔内部的斜坡系统\n   - 杠杆提升理论：使用木制杠杆系统提升石块\n\n5. **石块放置**：石块精确切割，几乎不需要砂浆。接缝如此精确，甚至无法插入一把刀。\n\n6. **外层处理**：最后用高质量的图拉石灰石覆盖整个结构，创造光滑的外表。\n\n这一过程需要数千名工人，而非奴隶(考古证据表明是有偿工人)，工期约20年。胡夫金字塔使用了约230万块石头，每块重约2.5吨，这一工程成就即使在今天看来也令人惊叹。",
                            timestamp: Date().addingTimeInterval(-172700)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "为什么埃及人如此痴迷于死后生活？",
                            timestamp: Date().addingTimeInterval(-172650)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "古埃及人对死后生活的关注源于其深刻的宗教和哲学体系，主要体现在以下几个方面：\n\n1. **循环与永恒观念**：埃及人观察到尼罗河的周期性泛滥、太阳的日常复活、季节的循环，形成了永恒轮回的世界观。死亡被视为生命循环的一部分，而非终点。\n\n2. **灵魂不死的信仰**：埃及人相信人有多个灵魂成分：\n   - **卡(Ka)**：生命力，需要食物和饮料\n   - **巴(Ba)**：个性，可离开身体游荡\n   - **阿赫(Akh)**：在来世转变的灵魂形式\n   保存这些灵魂组成部分是木乃伊制作的核心原因。\n\n3. **来世观念**：埃及人视死后世界为现世的延续，称为\"芦苇原\"(Aaru)，是一个理想化的埃及。在那里，死者可继续享受生活的乐趣，但没有疾病、痛苦或劳作。\n\n4. **审判观念**：死者心脏会被欧西里斯和42位神祇评判，称为\"心脏的称重\"，衡量一生的功过。这是世界上最早的道德审判概念之一。\n\n5. **政治与社会因素**：\n   - 法老被认为是神与人之间的中介，保持其在死后的神性地位对维持统治权威至关重要\n   - 复杂的丧葬传统和壮观的陵墓反映了社会等级，也服务于国家经济(创造就业、刺激手工业等)\n\n6. **抵抗遗忘的文化**：埃及人特别畏惧永久性的遗忘或灵魂消亡。他们相信只要名字和形象被记住，人就某种程度上继续存在，这就是为何墓中充满铭文和图像。\n\n这种对死后生活的关注产生了人类历史上最丰富的丧葬文化之一，影响了后世的许多宗教和哲学，甚至在某种程度上促进了医学、建筑和艺术的发展。",
                            timestamp: Date().addingTimeInterval(-172600)
                        )
                    ],
                    createdAt: Date().addingTimeInterval(-172800),
                    updatedAt: Date().addingTimeInterval(-172600)
                )
            ]
        )

        return [character1, character2, character3, character4, character5]
    }
}
