//
//  ChatViewModel.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/26.
//

import Foundation

@MainActor
class ChatViewModel: ObservableObject {
    @Published var currentCharacter: Character
    @Published var currentConversation: Conversation?
    @Published var messages: [Message] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let chatService: ChatServiceProtocol
    private let characterStore: CharacterStore

    // MARK: - 初始化

    init(characterId: UUID, chatService: ChatServiceProtocol = ChatService(), characterStore: CharacterStore = .shared) {
        self.chatService = chatService
        self.characterStore = characterStore

        // 尝试加载现有角色，如果不存在则创建新角色
        if let existCharacter = self.characterStore.loadCharacter(id: characterId) {
            self.currentCharacter = existCharacter
        } else {
            let newCharacter = Character(
                id: characterId,
                name: "新角色",
                settings: CharacterSettings(
                    modelParameters: LMStudioParameters(
                        model: "",
                        temperature: 0.7,
                        maxTokens: -1,
                        stream: false
                    ),
                    voiceParameters: nil,
                    systemPrompt: "You are a helpful assistant."
                ),
                conversations: []
            )

            // 保存新角色
            self.characterStore.saveCharacter(newCharacter)
            self.currentCharacter = newCharacter
        }
    }

    // MARK: - 加载数据

    // MARK: 加载角色

    func loadCharacter(for characterId: UUID, createIfNotExist: Bool = true) {
        if let character = characterStore.loadCharacter(id: characterId) {
            currentCharacter = character
            if let lastestConversation = character.conversations.sorted(by: { $0.updatedAt > $1.updatedAt }).first {
                // TODO: 加载对话Conversation
                loadConversation(for: lastestConversation.id)
            } else if createIfNotExist {
                // TODO: 角色存在但没有对话，创建一个默认对话
                createNewConversation(title: "新对话")
            }
        }
    }

    // MARK: 加载最新的对话，确保总有一个对话被加载

    func loadLatestConversation() {
        if let latestConversation = currentCharacter.conversations.sorted(by: { $0.updatedAt > $1.updatedAt }).first {
            loadConversation(for: latestConversation.id)
        } else {
            // 没有现有对话，创建一个
            createNewConversation(title: "新对话")
        }
    }

    // MARK: 加载对话

    func loadConversation(for conversationId: UUID) {
        guard let conversation = currentCharacter.conversations.first(where: { $0.id == conversationId })
        else {
            return
        }

        currentConversation = conversation
        messages = conversation.messages
    }

    // MARK: - 创建数据

    // MARK: 创建新对话

    func createNewConversation(title: String = "新对话") {
        if let newConversation = characterStore.createConversation(for: currentCharacter.id, title: title) {
            // 重新加载角色以获取更新的数据
            loadCharacter(for: currentCharacter.id)
            loadConversation(for: newConversation.id)
        }
    }

    // MARK: - 更新数据

    /// 更新角色名称
    /// - Parameter newName: 新的角色名称
    func updateCharacterName(_ newName: String) {
        // 创建更新后的角色
        let updatedCharacter = Character(
            id: currentCharacter.id,
            name: newName,
            settings: currentCharacter.settings,
            conversations: currentCharacter.conversations
        )

        // 保存更新后的角色
        characterStore.saveCharacter(updatedCharacter)

        // 更新当前角色
        currentCharacter = updatedCharacter
    }

    /// 更新角色设置
    /// - Parameter newSettings: 新的角色设置
    func updateCharacterSettings(_ newSettings: CharacterSettings) {
        // 创建更新后的角色
        let updatedCharacter = Character(
            id: currentCharacter.id,
            name: currentCharacter.name,
            settings: newSettings,
            conversations: currentCharacter.conversations
        )

        // 保存更新后的角色
        characterStore.saveCharacter(updatedCharacter)

        // 更新当前角色
        currentCharacter = updatedCharacter
    }

    /// 更新当前对话的标题
    /// - Parameter newTitle: 新的对话标题
    func updateConversationTitle(_ newTitle: String) {
        guard let conversation = currentConversation else { return }

        let updatedConversation = Conversation(
            id: conversation.id,
            characterId: conversation.characterId,
            title: newTitle,
            messages: conversation.messages,
            createdAt: conversation.createdAt,
            updatedAt: Date()
        )

        guard let index = currentCharacter.conversations.firstIndex(where: { $0.id == conversation.id }) else { return }

        var updatedConversations = currentCharacter.conversations
        updatedConversations[index] = updatedConversation

        // 更新角色
        let updatedCharacter = Character(
            id: currentCharacter.id,
            name: currentCharacter.name,
            settings: currentCharacter.settings,
            conversations: updatedConversations
        )

        // 保存更新后的对话
        characterStore.saveCharacter(updatedCharacter)

        currentCharacter = updatedCharacter
        currentConversation = updatedConversation
    }

    // MARK: - 删除数据

    // MARK: 删除对话

    /// 删除对话
    /// - Parameter conversationId: 要删除的对话ID
    /// - Returns: 是否删除成功
    @discardableResult
    func deleteConversation(id conversationId: UUID) -> Bool {
        guard let index = currentCharacter.conversations.firstIndex(where: { $0.id == conversationId }) else {
            errorMessage = "找不到要删除的对话"
            return false
        }

        // 是否是当前对话
        let isCurrentConversation = currentConversation?.id == conversationId

        // 先删除存储中的对话
        let isSuccessful = characterStore.deleteConversation(id: conversationId, for: currentCharacter.id)

        if isSuccessful {
            // 直接在内存中更新角色的对话列表
            var updatedConversations = currentCharacter.conversations
            updatedConversations.remove(at: index)

            // 创建更新后的角色
            let updatedCharacter = Character(
                id: currentCharacter.id,
                name: currentCharacter.name,
                settings: currentCharacter.settings,
                conversations: updatedConversations
            )

            currentCharacter = updatedCharacter

            if isCurrentConversation {
                currentConversation = currentCharacter.conversations.sorted(by: { $0.updatedAt > $1.updatedAt }).first
                messages = currentConversation?.messages ?? []
            }

            return true
        } else {
            errorMessage = "删除对话失败"
            return false
        }
    }

    // MARK: 删除当前对话

    /// 删除当前对话
    /// - Returns: 是否删除成功
    func deleteCurrentConversation() -> Bool {
        guard let conversationId = currentConversation?.id else {
            return false
        }

        return deleteConversation(id: conversationId)
    }

    // MARK: - 发送数据

    // MARK: 发送消息

    func sendMessage(_ content: String) async {
        guard let conversation = currentConversation else {
            errorMessage = "无法在没有对话的情况下发送消息"
            return
        }

        isLoading = true
        errorMessage = nil

        defer {
            // 关闭正在加载组件
            isLoading = false
        }

        // 创建用户消息
        let userMessage = Message(
            id: UUID(),
            conversationId: conversation.id,
            role: .user,
            content: content,
            timestamp: Date()
        )

        // 先更新UI
        messages.append(userMessage)

        do {
            // 发送到API
            let assistantMessage = try await chatService.sendMessage(userMessage, for: currentCharacter)

            // 保存用户消息
            characterStore.addMessageToConversation(userMessage, in: currentCharacter)

            // 保存AI消息
            characterStore.addMessageToConversation(assistantMessage, in: currentCharacter)

            // 更新UI
            messages.append(assistantMessage)

            // 重新加载最新数据
            loadCharacter(for: currentCharacter.id)
            loadConversation(for: conversation.id)
        } catch {
            errorMessage = "发送消息失败: \(error.localizedDescription)"
            // 关闭正在加载组件
//            isLoading = false
            // 从对话消息中移除最新的用户对话
            messages.removeLast()
            MyLog("AssistantMessage", error)
        }
    }
}
