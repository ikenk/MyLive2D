//
//  ChatView.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//

import SwiftUI

// MARK: - 聊天视图
struct ChatView: View {
    let characterId: UUID
    let conversationId: UUID
    
//    @StateObject private var viewModel: ChatViewModel
//    @State private var messageText = ""
//    @State private var showingSettings = false
//    
//    @EnvironmentObject var characterStore: CharacterStore
//    
//    init(characterId: UUID, conversationId: UUID) {
//        self.characterId = characterId
//        self.conversationId = conversationId
//        
//        // 注入依赖
//        _viewModel = StateObject(wrappedValue: ChatViewModel(
//            chatService: ChatService(),
//            characterStore: CharacterStore() // 这里应该改为共享的store
//        ))
//    }
    
    var body: some View {
        Text("Hello World")
//        VStack {
//            ScrollViewReader { proxy in
//                ScrollView {
//                    LazyVStack {
//                        ForEach(viewModel.messages, id: \.id) { message in
//                            MessageBubble(message: message)
//                                .id(message.id)
//                        }
//                    }
//                    .padding()
//                    .onChange(of: viewModel.messages.count) { _ in
//                        scrollToBottom(proxy: proxy)
//                    }
//                }
//            }
//            
//            HStack {
//                TextField("输入消息...", text: $messageText)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .disabled(viewModel.isLoading)
//                
//                Button(action: sendMessage) {
//                    Image(systemName: "paperplane.fill")
//                        .font(.system(size: 20))
//                }
//                .disabled(messageText.isEmpty || viewModel.isLoading)
//            }
//            .padding()
//        }
//        .navigationTitle(viewModel.currentConversation?.title ?? "对话")
//        .navigationBarItems(trailing: Button(action: { showingSettings = true }) {
//            Image(systemName: "gear")
//        })
//        .onAppear {
//            viewModel.loadCharacter(id: characterId)
//            viewModel.loadConversation(id: conversationId)
//        }
//        .overlay(
//            Group {
//                if viewModel.isLoading {
//                    ProgressView("AI 思考中...")
//                        .padding()
//                        .background(Color(.systemBackground))
//                        .cornerRadius(10)
//                        .shadow(radius: 5)
//                }
//            }
//        )
//        .alert(
//            "错误",
//            isPresented: Binding(
//                get: { viewModel.errorMessage != nil },
//                set: { if !$0 { viewModel.errorMessage = nil } }
//            ),
//            actions: {
//                Button("确定", role: .cancel) {}
//            },
//            message: {
//                if let error = viewModel.errorMessage {
//                    Text(error)
//                }
//            }
//        )
//        .sheet(isPresented: $showingSettings) {
//            if let character = viewModel.currentCharacter {
//                CharacterSettingsView(character: character)
//            }
//        }
    }
    
//    private func sendMessage() {
//        guard !messageText.isEmpty else { return }
//        
//        let content = messageText
//        messageText = ""
//        
//        Task {
//            await viewModel.sendMessage(content)
//        }
//    }
//    
//    private func scrollToBottom(proxy: ScrollViewProxy) {
//        if let lastMessageId = viewModel.messages.last?.id {
//            withAnimation {
//                proxy.scrollTo(lastMessageId, anchor: .bottom)
//            }
//        }
//    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                Text(message.content)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.leading, 60)
            } else {
                Text(message.content)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(15)
                    .padding(.trailing, 60)
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}

//#Preview {
//    ChatView()
//}
