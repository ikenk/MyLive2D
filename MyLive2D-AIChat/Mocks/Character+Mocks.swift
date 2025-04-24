//
//  Character+Mocks.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/23.
//

import Foundation

extension Character {
    /// 模拟角色数据
    static var mockCharacters: [Character] {
        // MARK: 角色1：助手角色

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
                ),
                Conversation(
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
                ),
                Conversation(
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
            ]
        )

        // MARK: 角色2：医疗顾问

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
                ),
                Conversation(
                    id: UUID(),
                    characterId: UUID(),
                    title: "营养建议",
                    messages: [
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "作为素食者，我如何确保获得足够的蛋白质？",
                            timestamp: Date().addingTimeInterval(-5000)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "作为素食者，你可以通过以下食物获取充足蛋白质：\n\n1. 豆类和豆制品：豆腐、豆浆、豆干、黑豆、鹰嘴豆、扁豆等\n2. 坚果和种子：杏仁、腰果、核桃、奇亚籽、亚麻籽、葵花籽\n3. 全谷物：藜麦、燕麦、糙米、荞麦\n4. 蔬菜：西兰花、菠菜、羽衣甘蓝、豌豆\n\n为确保营养均衡，建议：\n• 每餐搭配不同植物蛋白来源，以获取全部必需氨基酸\n• 考虑适量添加强化食品如植物奶\n• 关注维生素B12、铁、锌和钙的摄入\n\n如有特殊健康状况，建议咨询营养师制定个性化方案。",
                            timestamp: Date().addingTimeInterval(-4950)
                        )
                    ],
                    createdAt: Date().addingTimeInterval(-5000),
                    updatedAt: Date().addingTimeInterval(-4950)
                ),
                Conversation(
                    id: UUID(),
                    characterId: UUID(),
                    title: "运动伤害",
                    messages: [
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "跑步后膝盖疼痛，我应该如何处理？",
                            timestamp: Date().addingTimeInterval(-3500)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "跑步后膝盖疼痛可能是由多种原因引起的，包括跑者膝（髌股疼痛综合征）、髂胫束综合征或过度使用。以下是建议的处理方法：\n\n立即处理：\n• 休息：暂停跑步，给膝盖恢复时间\n• 冰敷：每次20分钟，一天数次\n• 压缩：使用弹性绷带提供支持\n• 抬高：休息时将腿部抬高\n• 非处方消炎药：如布洛芬可缓解疼痛和炎症（请按说明使用）\n\n恢复阶段：\n• 进行低冲击性活动如游泳或骑自行车\n• 逐渐重返跑步，从短距离慢速开始\n• 确保穿着合适的跑鞋\n• 加强膝盖周围肌肉的锻炼\n\n如果疼痛持续超过一周，疼痛严重影响日常活动，或出现肿胀、无法负重等症状，请咨询医生或理疗师进行专业评估和治疗。",
                            timestamp: Date().addingTimeInterval(-3450)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "有哪些可以加强膝盖的练习？",
                            timestamp: Date().addingTimeInterval(-3400)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "以下是几个可以加强膝盖周围肌肉的练习，有助于提供更好的支持和稳定性：\n\n1. 直腿抬高：\n   • 仰卧，一腿弯曲，另一腿伸直\n   • 缓慢抬起伸直的腿至约45度角\n   • 保持5秒，然后缓慢放下\n   • 每侧10-15次，3组\n\n2. 半蹲：\n   • 双脚与肩同宽，脚尖稍微向外\n   • 缓慢弯曲膝盖至45度角，就像坐椅子\n   • 确保膝盖不超过脚尖\n   • 保持3秒，然后站起\n   • 重复10-15次，3组\n\n3. 侧向移动：\n   • 站立，膝盖微屈\n   • 向侧边迈步，保持核心紧实\n   • 每侧10-15步，3组\n\n4. 单腿平衡：\n   • 站在一条腿上，微屈膝盖\n   • 保持平衡30秒\n   • 每侧重复3次\n\n5. 小腿拉伸：\n   • 面墙站立，一腿向前迈出\n   • 后腿保持伸直，脚跟贴地\n   • 向前倾斜感受小腿拉伸\n   • 每侧保持30秒，重复3次\n\n建议从简单的开始，逐渐增加难度和次数。如果任何练习引起疼痛，应立即停止并咨询专业人士指导。在开始新运动计划前，特别是如果你有现有伤病，建议先咨询医生或理疗师。",
                            timestamp: Date().addingTimeInterval(-3350)
                        )
                    ],
                    createdAt: Date().addingTimeInterval(-3500),
                    updatedAt: Date().addingTimeInterval(-3350)
                ),
                Conversation(
                    id: UUID(),
                    characterId: UUID(),
                    title: "睡眠问题",
                    messages: [
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .user,
                            content: "我经常晚上难以入睡，有什么方法可以改善睡眠质量？",
                            timestamp: Date().addingTimeInterval(-1800)
                        ),
                        Message(
                            id: UUID(),
                            conversationId: UUID(),
                            role: .assistant,
                            content: "改善睡眠质量的方法有很多，以下是一些实用的睡眠卫生建议：\n\n建立规律：\n• 每天相同时间入睡和起床，包括周末\n• 创建放松的睡前仪式，如阅读、冥想或泡温水澡\n\n优化睡眠环境：\n• 保持卧室凉爽、安静和黑暗\n• 使用舒适的床垫和枕头\n• 减少卧室内电子设备\n\n健康习惯：\n• 白天保持活跃，定期运动（但避免睡前3小时剧烈运动）\n• 限制咖啡因摄入，尤其是下午和晚上\n• 避免大量饮酒，虽然酒精可能帮助入睡，但会影响睡眠质量\n• 晚餐不宜过饱或过晚\n\n控制光线接触：\n• 白天多接触自然光\n• 晚上减少蓝光暴露（电子屏幕）\n• 睡前1-2小时可使用暖光或低亮度灯光\n\n心理策略：\n• 尝试深呼吸或渐进式肌肉放松\n• 记录担忧事项，留到明天处理\n• 如20分钟内无法入睡，起床做安静活动直到感到困倦\n\n如果持续存在睡眠问题，请咨询医生，可能需要评估是否有睡眠障碍或其他健康问题。",
                            timestamp: Date().addingTimeInterval(-1750)
                        )
                    ],
                    createdAt: Date().addingTimeInterval(-1800),
                    updatedAt: Date().addingTimeInterval(-1750)
                )
            ]
        )

        // MARK: 角色3：编程教练

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

        // MARK: 角色4：旅行顾问

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

        // MARK: 角色5：历史学者

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
