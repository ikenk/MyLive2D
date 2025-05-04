////
////  template.swift
////  MyLive2D
////
////  Created by HT Zhang  on 2025/04/25.
////
//
//
////
////  CharacterStore.swift
////  MyLive2D
////
////  Created by HT Zhang  on 2025/04/22.
////
//
//import Foundation
//
//// 在应用启动时
//func checkAndCreateDefaultCharacter() {
//    // 如果没有任何角色，创建一个默认角色
//    if characterStore.characters.isEmpty {
//        let defaultCharacter = Character(
//            id: UUID(),
//            name: "默认助手",
//            settings: CharacterSettings(
//                modelParameters: LMStudioParameters(
//                    model: "deepseek-r1-distill-qwen-1.5b",
//                    temperature: 0.7,
//                    maxTokens: -1,
//                    stream: false
//                ),
//                voiceParameters: nil,
//                systemPrompt: "You are a helpful assistant."
//            ),
//            conversations: []
//        )
//        
//        characterStore.saveCharacter(defaultCharacter)
//        
//        // 加载这个默认角色
//        loadCharacter(id: defaultCharacter.id)
//    }
//}
//
//class CharacterStore: ObservableObject {
//    @Published private(set) var characters: [Character] = []
//
//    private let fileManager = FileManager.default
//    private var documentDirectory: URL {
//        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    }
//    
//    init() {
//        loadAllCharacters()
//    }
//
//    /// 获取角色目录
//    private func characterDirectory() -> URL {
//        documentDirectory.appendingPathComponent("Characters")
//    }
//
//    /// 获取特定角色目录
//    private func characterFilesURL(for characterId: UUID) -> URL {
//        characterDirectory().appendingPathComponent("\(characterId.uuidString)")
//    }
//
//    /// 获取对话目录
//    private func conversationsDirectory(for characterId: UUID) -> URL {
//        characterFilesURL(for: characterId).appendingPathComponent("Conversations")
//    }
//
//    /// 获取特定对话的文件URL
//    private func conversationFileURL(for characterId: UUID, and conversationId: UUID) -> URL {
//        conversationsDirectory(for: characterId).appendingPathComponent("\(conversationId.uuidString).json")
//    }
//
//    /// 加载所有角色
//    func loadAllCharacters() {
//        // 角色目录 /Characters
//        let charactersDirectory = characterDirectory()
//
//        do {
//            // 防御性编程，防止没有/Characters导致的报错
//            try fileManager.createDirectory(at: charactersDirectory, withIntermediateDirectories: true)
//
//            /// 获取所有角色目录（每个角色一个目录）
//            let charactersDirectories = try fileManager.contentsOfDirectory(at: charactersDirectory, includingPropertiesForKeys: nil).filter {
//                var isDirectory: ObjCBool = false
//                fileManager.fileExists(atPath: $0.path, isDirectory: &isDirectory)
//                return isDirectory.boolValue
//            }
//
//            // 加载每个角色
//            characters = charactersDirectories.compactMap { directory in
//                let characterId = UUID(uuidString: directory.lastPathComponent)
//                guard let characterId = characterId else { return nil }
//
//                // 特定角色目录中的character.json的实际路径
//                let characterFileURL = directory.appendingPathComponent("character.json")
//
//                do {
//                    // 读取角色基本信息
//                    let characterData = try Data(contentsOf: characterFileURL)
//                    var character = try JSONDecoder().decode(Character.self, from: characterData)
//
//                    // 加载该角色的所有对话
//                    character.conversations = loadConversationsForCharacter(id: characterId)
//
//                    return character
//
//                } catch {
//                    print("加载角色失败: \(directory.lastPathComponent), 错误: \(error)")
//                    return nil
//                }
//            }
//
//        } catch {
//            print("加载角色列表失败: \(error)")
//        }
//    }
//
//    /// 加载指定角色
//    func loadCharacter(id: UUID) -> Character? {
//        // 首先检查内存中是否已有该角色
//        if let character = characters.first(where: { $0.id == id }) {
//            return character
//        }
//
//        // 如果内存中没有，尝试从文件加载
//        let characterDirectory = characterFilesURL(for: id)
//
//        do {
//            // 检查目录是否存在
//            guard fileManager.fileExists(atPath: characterDirectory.path) else { return nil }
//            
//            let characterFileURL = characterDirectory.appendingPathComponent("character.json")
//
//            // 检查文件是否存在
//            guard fileManager.fileExists(atPath: characterFileURL.path) else { return nil }
//
//            // 读取角色基本信息
//            let characterData = try Data(contentsOf: characterFileURL)
//            var character = try JSONDecoder().decode(Character.self, from: characterData)
//
//            character.conversations = loadConversationsForCharacter(id: id)
//
//            return character
//        } catch {
//            print("加载角色失败: \(id.uuidString), 错误: \(error)")
//            return nil
//        }
//    }
//
//    /// 加载角色的所有对话
//    private func loadConversationsForCharacter(id: UUID) -> [Conversation] {
//        // 获取 /Conversations 目录
//        let conversationsDir = conversationsDirectory(for: id)
//        
//        // 检查目录是否存在
//        guard fileManager.fileExists(atPath: conversationsDir.path) else { return [] }
//        
//        do {
//            // 获取所有.json对话文件的URL
//            let conversationFilesURL = try fileManager.contentsOfDirectory(at: conversationsDir, includingPropertiesForKeys: nil).filter { directory in
//                directory.pathExtension == "json"
//            }
//
//            // 从对话文件中提取[Conversation]
//            let conversations = conversationFilesURL.compactMap { fileURL in
//                do {
//                    let conversationData = try Data(contentsOf: fileURL)
//                    return try JSONDecoder().decode(Conversation.self, from: conversationData)
//                } catch {
//                    print("加载对话失败: \(fileURL.lastPathComponent), 错误: \(error)")
//                    return nil
//                }
//            }
//
//            return conversations
//
//        } catch {
//            print("加载对话目录失败: \(error)")
//            return []
//        }
//    }
//
//    /// 保存角色基本信息（不包括对话）
//    private func saveCharacterInfo(_ character: Character) {
//        // 保存单独角色的路径
//        let characterFilesDir = characterFilesURL(for: character.id)
//        // 保存单独角色的路径下的character.json
//        let characterInfoURL = characterFilesDir.appendingPathComponent("character.json")
//
//        do {
//            try fileManager.createDirectory(at: characterFilesDir, withIntermediateDirectories: true)
//
//            // 创建一个不包含conversations的角色副本
//            var characterCopy = character
//            characterCopy.conversations = [] // 清空对话，单独保存
//
//            let data = try JSONEncoder().encode(characterCopy)
//            try data.write(to: characterInfoURL)
//            
//        } catch {
//            print("保存角色信息失败: \(error)")
//        }
//    }
//
//    /// 保存单个对话
//    private func saveConversation(_ conversation: Conversation, for characterId: UUID) {
//        // 首先确保会话目录存在
//        let conversationsDir = conversationsDirectory(for: characterId)
//        
//        do {
//            try fileManager.createDirectory(at: conversationsDir, withIntermediateDirectories: true)
//            
//            // 获取当前Conversation的完整路径
//            let fileURL = conversationFileURL(for: characterId, and: conversation.id)
//
//            let data = try JSONEncoder().encode(conversation)
//            try data.write(to: fileURL)
//        } catch {
//            print("保存对话失败: \(error)")
//        }
//    }
//
//    /// 创建新角色
//    @discardableResult
//    func createCharacter(name: String, settings: CharacterSettings) -> Character {
//        let character = Character(
//            id: UUID(),
//            name: name,
//            settings: settings,
//            conversations: []
//        )
//        
//        saveCharacter(character)
//        return character
//    }
//    
//    /// 创建新对话
//    @discardableResult
//    func createConversation(for characterId: UUID, title: String) -> Conversation? {
//        guard var character = loadCharacter(id: characterId) else {
//            return nil
//        }
//        
//        let conversation = Conversation(
//            id: UUID(),
//            characterId: characterId,
//            title: title,
//            messages: [],
//            createdAt: Date(),
//            updatedAt: Date()
//        )
//        
//        character.conversations.append(conversation)
//        saveConversation(conversation, for: characterId)
//        
//        // 更新内存中的数据
//        if let index = characters.firstIndex(where: { $0.id == characterId }) {
//            characters[index] = character
//        }
//        
//        return conversation
//    }
//
//    /// 保存角色和它的所有对话
//    func saveCharacter(_ character: Character) {
//        // 更新内存中的数据
//        if let index = characters.firstIndex(where: { $0.id == character.id }) {
//            characters[index] = character
//        } else {
//            characters.append(character)
//        }
//
//        // 保存角色基本信息
//        saveCharacterInfo(character)
//
//        // 保存每个对话
//        for conversation in character.conversations {
//            saveConversation(conversation, for: character.id)
//        }
//    }
//
//    /// 添加消息到对话
//    func addMessageToConversation(_ message: Message, in conversationId: UUID, for characterId: UUID) -> Bool {
//        guard var character = loadCharacter(id: characterId),
//              let conversationIndex = character.conversations.firstIndex(where: { $0.id == conversationId })
//        else {
//            return false
//        }
//
//        // 添加消息
//        character.conversations[conversationIndex].messages.append(message)
//        character.conversations[conversationIndex].updatedAt = Date()
//
//        // 保存更改（只需保存修改的对话）
//        let updatedConversation = character.conversations[conversationIndex]
//        saveConversation(updatedConversation, for: characterId)
//
//        // 更新内存中的数据
//        if let characterIndex = characters.firstIndex(where: { $0.id == character.id }) {
//            characters[characterIndex] = character
//        }
//        
//        return true
//    }
//    
//    /// 删除角色
//    func deleteCharacter(id: UUID) -> Bool {
//        let characterDir = characterFilesURL(for: id)
//        
//        do {
//            if fileManager.fileExists(atPath: characterDir.path) {
//                try fileManager.removeItem(at: characterDir)
//            }
//            
//            // 更新内存中的数据
//            characters.removeAll { $0.id == id }
//            return true
//        } catch {
//            print("删除角色失败: \(error)")
//            return false
//        }
//    }
//    
//    /// 删除对话
//    func deleteConversation(id: UUID, for characterId: UUID) -> Bool {
//        let conversationFile = conversationFileURL(for: characterId, and: id)
//        
//        do {
//            if fileManager.fileExists(atPath: conversationFile.path) {
//                try fileManager.removeItem(at: conversationFile)
//            }
//            
//            // 更新内存中的数据
//            if let characterIndex = characters.firstIndex(where: { $0.id == characterId }) {
//                characters[characterIndex].conversations.removeAll { $0.id == id }
//            }
//            
//            return true
//        } catch {
//            print("删除对话失败: \(error)")
//            return false
//        }
//    }
//}
//
//
//
////
////  ChatViewModel.swift
////  MyLive2D
////
////  Created by HT Zhang  on 2025/04/22.
////
//
//import Foundation
//import Combine
//
//class ChatViewModel: ObservableObject {
//    @Published var currentCharacter: Character?
//    @Published var currentConversation: Conversation?
//    @Published var messages: [Message] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    private let chatService: ChatServiceProtocol
//    private let characterStore: CharacterStore
//    
//    init(chatService: ChatServiceProtocol = ChatService(),
//         characterStore: CharacterStore) {
//        self.chatService = chatService
//        self.characterStore = characterStore
//    }
//    
//    // 加载角色
//    func loadCharacter(id: UUID) {
//        guard let character = characterStore.loadCharacter(id: id) else {
//            errorMessage = "找不到该角色"
//            return
//        }
//        
//        currentCharacter = character
//        
//        // 如果有对话记录，加载最新的一个
//        if let latestConversation = character.conversations.sorted(by: { $0.updatedAt > $1.updatedAt }).first {
//            loadConversation(id: latestConversation.id)
//        }
//    }
//    
//    // 加载角色，如果不存在则创建
//    func loadCharacter(id: UUID, createIfNotExist: Bool = true) {
//        // 尝试加载现有角色
//        if let character = characterStore.loadCharacter(id: id) {
//            currentCharacter = character
//            
//            // 如果有对话记录，加载最新的一个
//            if let latestConversation = character.conversations.sorted(by: { $0.updatedAt > $1.updatedAt }).first {
//                loadConversation(id: latestConversation.id)
//            } else if createIfNotExist {
//                // 角色存在但没有对话，创建一个默认对话
//                createNewConversation(title: "新对话")
//            }
//        } else if createIfNotExist {
//            // 角色不存在，创建一个新角色
//            let newCharacter = Character(
//                id: id,
//                name: "新角色",  // 可以使用默认名称，稍后允许用户修改
//                settings: CharacterSettings(
//                    modelParameters: LMStudioParameters(
//                        model: "deepseek-r1-distill-qwen-1.5b",
//                        temperature: 0.7,
//                        maxTokens: -1,
//                        stream: false
//                    ),
//                    voiceParameters: nil,
//                    systemPrompt: "You are a helpful assistant."
//                ),
//                conversations: []
//            )
//            
//            // 保存新角色
//            characterStore.saveCharacter(newCharacter)
//            currentCharacter = newCharacter
//            
//            // 为新角色创建一个默认对话
//            createNewConversation(title: "初次对话")
//        } else {
//            // 角色不存在且不自动创建
//            errorMessage = "找不到该角色"
//        }
//    }
//    
//    // 加载对话
//    func loadConversation(id: UUID) {
//        guard let character = currentCharacter,
//              let conversation = character.conversations.first(where: { $0.id == id }) else {
//            return
//        }
//        
//        currentConversation = conversation
//        messages = conversation.messages
//    }
//    
//    // 创建新对话
//    func createNewConversation(title: String = "新对话") {
//        guard let character = currentCharacter else { return }
//        
//        if let conversation = characterStore.createConversation(for: character.id, title: title) {
//            // 重新加载角色以获取更新的数据
//            loadCharacter(id: character.id)
//            loadConversation(id: conversation.id)
//        }
//    }
//    
//    // 发送消息
//    func sendMessage(_ content: String) async {
//        guard let character = currentCharacter,
//              let conversation = currentConversation else {
//            errorMessage = "请先选择角色和对话"
//            return
//        }
//        
//        isLoading = true
//        errorMessage = nil
//        
//        do {
//            // 创建用户消息
//            let userMessage = Message(
//                id: UUID(),
//                conversationId: conversation.id,
//                role: .user,
//                content: content,
//                timestamp: Date()
//            )
//            
//            // 保存用户消息
//            let addedSuccessfully = characterStore.addMessageToConversation(
//                userMessage,
//                in: conversation.id,
//                for: character.id
//            )
//            
//            if !addedSuccessfully {
//                throw NSError(domain: "ChatViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "无法保存消息"])
//            }
//            
//            await MainActor.run {
//                messages.append(userMessage)
//            }
//            
//            // 发送请求
//            let assistantMessage = try await chatService.sendMessage(userMessage, for: character)
//            
//            // 保存助手回复
//            let assistantAddedSuccessfully = characterStore.addMessageToConversation(
//                assistantMessage,
//                in: conversation.id,
//                for: character.id
//            )
//            
//            if !assistantAddedSuccessfully {
//                throw NSError(domain: "ChatViewModel", code: 1, userInfo: [NSLocalizedDescriptionKey: "无法保存助手回复"])
//            }
//            
//            await MainActor.run {
//                messages.append(assistantMessage)
//            }
//            
//        } catch {
//            await MainActor.run {
//                errorMessage = "发送消息失败: \(error.localizedDescription)"
//            }
//        }
//        
//        await MainActor.run {
//            isLoading = false
//        }
//    }
//    
//    // 删除当前对话
//    func deleteCurrentConversation() {
//        guard let character = currentCharacter,
//              let conversation = currentConversation else {
//            return
//        }
//        
//        let deleted = characterStore.deleteConversation(id: conversation.id, for: character.id)
//        
//        if deleted {
//            currentConversation = nil
//            messages = []
//            
//            // 加载最新的一个对话（如果有）
//            loadCharacter(id: character.id)
//        }
//    }
//}
//
//
////
////  ChatService.swift
////  MyLive2D
////
////  Created by HT Zhang  on 2025/04/22.
////
//
//import Foundation
//
//protocol ChatServiceProtocol {
//    func sendMessage(_ message: Message, for character: Character) async throws -> Message
//}
//
//class ChatService: ChatServiceProtocol {
//    private let networkManager: NetworkManager
//    
//    init(networkManager: NetworkManager = .shared) {
//        self.networkManager = networkManager
//    }
//    
//    func sendMessage(_ message: Message, for character: Character) async throws -> Message {
//        // API请求模型
//        struct ChatRequest: Encodable {
//            let content: String
//            let characterId: String
//            let modelParameters: LMStudioParameters
//        }
//        
//        struct ChatResponse: Decodable {
//            let message: String
//            let characterId: String
//        }
//        
//        // 准备请求数据
//        let requestBody = ChatRequest(
//            content: message.content,
//            characterId: character.id.uuidString,
//            modelParameters: character.settings.modelParameters
//        )
//        
//        let request = HTTPRequest(
//            path: "v1/chat/completions",
//            method: .post,
//            headers: ["Content-Type": "application/json"],
//            body: try JSONEncoder().encode(requestBody)
//        )
//        
//        // 发送请求
//        let response: ChatResponse = try await networkManager.request(request)
//        
//        // 创建新的助手消息
//        let assistantMessage = Message(
//            id: UUID(),
//            conversationId: message.conversationId,
//            role: .assistant,
//            content: response.message,
//            timestamp: Date(),
//            audioUrl: nil // 暂时不处理语音
//        )
//        
//        return assistantMessage
//    }
//}
