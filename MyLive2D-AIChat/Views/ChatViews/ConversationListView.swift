//
//  ConversationListView.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/23.
//

import SwiftUI

struct ConversationListView: View {
    let character: Character = Character.mockCharacters[0]
//    @EnvironmentObject var characterStore: CharacterStore
    @State private var showingAddConversation = false
    @State private var newConversationTitle = "新对话"
    
    var body: some View {
        List {
            ForEach(character.conversations.sorted(by: { $0.updatedAt > $1.updatedAt }), id: \.id) { conversation in
                NavigationLink(destination: ChatView(characterId: character.id, conversationId: conversation.id)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(conversation.title)
                            .font(.headline)
                        
                        HStack {
                            Text(formattedDate(conversation.updatedAt))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text("\(conversation.messages.count)条消息")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .onDelete(perform: deleteConversation)
        }
        .navigationTitle("\(character.name)的对话")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddConversation = true }) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        .alert("新建对话", isPresented: $showingAddConversation) {
            TextField("对话标题", text: $newConversationTitle)
            Button("取消", role: .cancel) { newConversationTitle = "新对话" }
            Button("创建") { createNewConversation() }
        } message: {
            Text("请输入新对话的标题")
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func deleteConversation(at offsets: IndexSet) {
        let sortedConversations = character.conversations.sorted(by: { $0.updatedAt > $1.updatedAt })
//        for offset in offsets {
//            let conversation = sortedConversations[offset]
//            _ = characterStore.deleteConversation(id: conversation.id, for: character.id)
//        }
    }
    
    private func createNewConversation() {
        guard !newConversationTitle.isEmpty else { return }
        
//        _ = characterStore.createConversation(for: character.id, title: newConversationTitle)
        newConversationTitle = "新对话"
    }
}


#Preview {
    ConversationListView()
}
