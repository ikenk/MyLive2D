//
//  CharacterStore.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/22.
//

import Foundation

class CharacterStore:ObservableObject {
    static let shared = CharacterStore()

    private(set) var characters: [Character] = []

    private let fileManager = FileManager.default
    private var documentDirectory: URL {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    // MARK: - 获取xxx路径
    // MARK: 获取存储角色文件的路径

    /// 获取角色目录
    private func characterDirectory()->URL {
        documentDirectory.appendingPathComponent("Characters")
    }

    // MARK: 获取特定角色的路径

    /// 获取特定角色目录
    private func characterFilesURL(for characterId: UUID)->URL {
        characterDirectory().appendingPathComponent("\(characterId.uuidString)")
    }

    // MARK: 获取存储对话文件的路径

    /// 获取对话目录
    private func conversationsDirectory(for characterId: UUID)->URL {
        characterFilesURL(for: characterId).appendingPathComponent("Conversations")
    }

    // MARK: 获取特定对话文件的路径

    /// 获取特定对话的文件URL
    private func conversationFileURL(for characterId: UUID, and conversationId: UUID)->URL {
        conversationsDirectory(for: characterId).appendingPathComponent("\(conversationId.uuidString)", conformingTo: .json)
    }

    // MARK: - 加载数据
    // MARK: 加载所有角色

    /// 加载所有角色
    func loadAllCharacters() {
        // 角色目录 /Characters
        let charactersDirectory = characterDirectory()

        do {
            // 防御性编程，防止没有/Characters导致的报错
            try fileManager.createDirectory(at: charactersDirectory, withIntermediateDirectories: true)

            /// 获取所有角色目录（每个角色一个目录）
            let charactersDirectories = try fileManager.contentsOfDirectory(at: charactersDirectory, includingPropertiesForKeys: nil).filter {
                var isDirectory: ObjCBool = false
                fileManager.fileExists(atPath: $0.path(), isDirectory: &isDirectory)
                return isDirectory.boolValue
            }

            // 加载每个角色
            characters = charactersDirectories.compactMap { directory in
                let characterId = UUID(uuidString: directory.lastPathComponent)
                guard let characterId = characterId else { return nil }

                // 特定角色目录中的character.json的实际路径
                let characterFileURL = directory.appendingPathComponent("character", conformingTo: .json)

                do {
                    // 读取角色基本信息
                    let characterData = try Data(contentsOf: characterFileURL)
                    var character = try JSONDecoder().decode(Character.self, from: characterData)

                    // 加载该角色的所有对话
                    character.conversations = loadConversationsForCharacter(id: characterId)

                    return character

                } catch {
//                    print("加载角色失败: \(directory.lastPathComponent), 错误: \(error)")
                    MyLog("加载角色失败", directory.lastPathComponent)
                    MyLog("错误", error)
                    return nil
                }
            }

        } catch {
//            print("加载角色列表失败: \(error)")
            MyLog("加载角色列表失败", error)
        }
    }

    // MARK: 加载指定角色

    /// 加载指定角色
    func loadCharacter(id: UUID)->Character? {
        // 首先检查内存中是否已有该角色
        if let character = characters.first(where: { $0.id == id }) {
            return character
        }

        // 如果内存中没有，尝试从文件加载
        let characterDirectory = characterFilesURL(for: id)

        do {
            try fileManager.createDirectory(at: characterDirectory, withIntermediateDirectories: true)

            let characterFileURL = characterDirectory.appendingPathComponent("character", conformingTo: .json)

            // 检查文件是否存在
            guard fileManager.fileExists(atPath: characterFileURL.path()) else { return nil }

            // 读取角色基本信息
            let characterData = try Data(contentsOf: characterFileURL)
            var character = try JSONDecoder().decode(Character.self, from: characterData)

            character.conversations = loadConversationsForCharacter(id: id)

            return character
        } catch {
//            print("加载角色失败: \(id.uuidString), 错误: \(error)")
            MyLog("加载角色失败", id.uuidString)
            MyLog("错误", error)
            return nil
        }
    }

    // MARK: 加载指定角色的所有对话

    /// 加载角色的所有对话
    private func loadConversationsForCharacter(id: UUID)->[Conversation] {
        // 获取 /Conversations 目录
        let conversationsDir = conversationsDirectory(for: id)
        do {
            try fileManager.createDirectory(at: conversationsDir, withIntermediateDirectories: true)

            // 获取所有.json对话文件的URL
            let conversationFilesURL = try fileManager.contentsOfDirectory(at: conversationsDir, includingPropertiesForKeys: nil).filter { directory in
                directory.pathExtension == "json"
            }

            // 从对话文件中提取[Conversation]
            let conversations = conversationFilesURL.compactMap { fileURL in
                do {
                    let conversationData = try Data(contentsOf: fileURL)

                    return try JSONDecoder().decode(Conversation.self, from: conversationData)
                } catch {
//                    print("加载对话失败: \(fileURL.lastPathComponent), 错误: \(error)")
                    MyLog("加载对话失败", fileURL.lastPathComponent)
                    MyLog("错误", error)
                    return nil
                }
            }

            return conversations

        } catch {
//            print("加载对话目录失败: \(error)")
            MyLog("加载对话目录失败", error)
            return []
        }
    }

    // MARK: - 创建新数据
    // MARK: 创建新角色

    /// 创建新角色
    @discardableResult
    func createCharacter(name: String, settings: CharacterSettings)->Character {
        let newCharacter = Character(
            id: UUID(),
            name: name,
            settings: settings,
            conversations: []
        )

        saveCharacter(newCharacter)

        return newCharacter
    }

    // MARK: 创建新对话

    /// 创建新对话
    @discardableResult
    func createConversation(for characterId: UUID, title: String)->Conversation? {
        guard var character = loadCharacter(id: characterId) else { return nil }

        let newConversation = Conversation(
            id: UUID(),
            characterId: characterId,
            title: title,
            messages: [],
            createdAt: Date(),
            updatedAt: Date()
        )

        character.conversations.append(newConversation)
        saveConversation(newConversation, for: characterId)

        // 更新内存中的数据
        if let index = characters.firstIndex(where: { $0.id == characterId }) {
            characters[index] = character
        }

        return newConversation
    }

    // MARK: - 保存数据
    // MARK: 保存角色基本信息（不包括对话）

    /// 保存角色基本信息（不包括对话）
    private func saveCharacterInfo(_ character: Character) {
        // 保存单独角色的路径
        let characterFilesDir = characterFilesURL(for: character.id)
        // 保存单独角色的路径下的character.json
        let characterInfoURL = characterFilesDir.appendingPathComponent("character", conformingTo: .json)

        do {
            try fileManager.createDirectory(at: characterFilesDir, withIntermediateDirectories: true)

            // 创建一个不包含conversations的角色副本
            var characterCopy = character
            characterCopy.conversations = [] // 清空对话，单独保存

            let data = try JSONEncoder().encode(characterCopy)
            try data.write(to: characterInfoURL)
            
            print(characterInfoURL)
            
            print("saveCharacterInfo run")

        } catch {
            MyLog("保存角色信息失败", error)
//            print("保存角色信息失败: \(error)")
        }
    }

    // MARK: 保存单个对话

    /// 保存单个对话
    private func saveConversation(_ conversation: Conversation, for characterId: UUID) {
        // 获取当前Conversation所在的文件夹目录
        let conversationsDir = conversationsDirectory(for: characterId)
        // 获取当前Conversation的完整路径
        let fileURL = conversationFileURL(for: characterId, and: conversation.id)

        do {
            try fileManager.createDirectory(at: conversationsDir, withIntermediateDirectories: true)

            let data = try JSONEncoder().encode(conversation)
            try data.write(to: fileURL)
            
            print("saveConversation run")
        } catch {
            MyLog("保存对话失败", error)
//            print("保存对话失败: \(error)")
        }
    }

    // MARK: 保存角色和它的所有对话

    /// 保存角色和它的所有对话
    func saveCharacter(_ character: Character) {
        // 更新内存中的数据
        if let index = characters.firstIndex(where: { $0.id == character.id }) {
            characters[index] = character
        } else {
            characters.append(character)
        }

        // 保存角色基本信息
        saveCharacterInfo(character)

        // 保存每个对话
        for conversation in character.conversations {
            saveConversation(conversation, for: character.id)
        }
    }

    // MARK: 添加消息到对话

    /// 添加消息到对话
    func addMessageToConversation(_ message: Message, in character: Character) {
        guard var character = loadCharacter(id: character.id),
              let conversationIndex = character.conversations.firstIndex(where: { $0.id == message.conversationId })
        else {
            return
        }

        // 添加消息
        character.conversations[conversationIndex].messages.append(message)
        character.conversations[conversationIndex].updatedAt = Date()

        // 保存更改（只需保存修改的对话）
        let updatedConversation = character.conversations[conversationIndex]
        saveConversation(updatedConversation, for: character.id)

        // 更新内存中的数据
        if let characterIndex = characters.firstIndex(where: { $0.id == character.id }) {
            characters[characterIndex] = character
        }
    }

    // MARK: - 删除数据
    // MARK: 删除角色

    /// 删除角色
    func deleteCharacter(id: UUID)->Bool {
        let characterDir = characterFilesURL(for: id)

        do {
            if fileManager.fileExists(atPath: characterDir.path()) {
                try fileManager.removeItem(at: characterDir)
            }

            // 更新内存中的数据
            characters.removeAll {
                $0.id == id
            }

            return true
        } catch {
//            print("删除角色失败 \(error)")
            MyLog("删除角色失败", error)
            return false
        }
    }

    // MARK: 删除对话

    /// 删除对话
    func deleteConversation(id: UUID, for characterId: UUID)->Bool {
        let conversationFile = conversationFileURL(for: characterId, and: id)

        do {
            if fileManager.fileExists(atPath: conversationFile.path()) {
                try fileManager.removeItem(at: conversationFile)
            }

            // 更新内存中的数据
            if let characterIndex = characters.firstIndex(where: { $0.id == characterId }) {
                characters[characterIndex].conversations.removeAll { $0.id == id }
            }

            return true
        } catch {
//            print("删除对话失败: \(error)")
            MyLog("删除对话失败", error)
            return false
        }
    }
}
