//
//  ChatViewModel.swift.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/24.
//

import Foundation

//class ChatViewModel: ObservableObject {
//    @Published var currentCharacter: Character?
//    @Published var currentConversation: Conversation?
//    @Published var messages: [Message] = []
//    @Published var isLoading: Bool = false
//    @Published var errorMessage: String?
//
//    private let chatService: ChatServiceProtocol
//    private let characterStore: CharacterStore
//
//    init(chatService: ChatServiceProtocol = ChatService(), characterStore: CharacterStore = .shared) {
//        self.chatService = chatService
//        self.characterStore = characterStore
//    }
//
//    // MARK: 加载角色，如果不存在则创建
//
//    func loadCharacter(for characterId: UUID, createIfNotExist: Bool = true) {
//        if let character = characterStore.loadCharacter(id: characterId) {
//            currentCharacter = character
//            if let lastestConversation = character.conversations.sorted(by: { $0.updatedAt > $1.updatedAt }).first {
//                // TODO: 加载对话Conversation
//                loadConversation(for: lastestConversation.id)
//            } else if createIfNotExist {
//                // TODO: 角色存在但没有对话，创建一个默认对话
//                createNewConversation(title: "新对话")
//            }
//        } else if createIfNotExist {
//            // 角色不存在，创建一个新角色
//            let newCharacter = Character(
//                id: characterId,
//                name: "新角色",
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
//            // TODO: 为新角色创建一个默认
//            createNewConversation(title: "初次对话")
//        } else {
//            // 角色不存在且不自动创建
//            errorMessage = "找不到该角色"
//        }
//    }
//    
//    // MARK: 加载对话
//    func loadConversation(for conversationId:UUID) {
//        guard let character = currentCharacter,
//              let conversation = character.conversations.first(where: { $0.id == conversationId}) else {
//            return
//        }
//        
//        
//        currentConversation = conversation
//        messages = conversation.messages
//    }
//    
//    // MARK: 创建新对话
//    func createNewConversation(title: String = "新对话"){
//        guard let character = currentCharacter else { return }
//        
//        if let newConversation = characterStore.createConversation(for: character.id, title: title){
//            // 重新加载角色以获取更新的数据
//            loadCharacter(for: character.id)
//            loadConversation(for:newConversation.id)
//        }
//    }
//}
