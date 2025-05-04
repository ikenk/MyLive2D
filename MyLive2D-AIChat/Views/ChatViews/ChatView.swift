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
    let conversationId: UUID?
    @State private var messageText = ""
    @State private var showingConversationList = false
    @State private var showingSettings = false
    @StateObject private var viewModel: ChatViewModel

    init(
        characterId: UUID,
        conversationId: UUID?
    ) {
        self.characterId = characterId
        self.conversationId = conversationId
        self._viewModel = StateObject(wrappedValue: ChatViewModel(characterId: characterId))
    }

//    var messages: [Message] = PreviewData.mockCharacters[0].conversations[0].messages
//    var characterName = PreviewData.mockCharacters[0].name
//    var conversationTitle = PreviewData.mockCharacters[0].conversations[0].title

    var body: some View {
        ZStack {
            // MARK: 主聊天视图

            VStack {
                CustomNavigationBar(
                    characterName: viewModel.currentCharacter.name,
                    conversationTitle: viewModel.currentConversation?.title ?? "无对话",
                    leftIcon: Image(systemName: "square.grid.2x2")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.title2)
                        .frame(width: 40, height: 40)
                        .cornerRadius(12),
                    rightIcon: Image(systemName: "gearshape.fill")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.title)
                        .frame(width: 40, height: 40)
                        .cornerRadius(12)
                ) {
                    withAnimation(.spring()) {
                        showingConversationList.toggle()
                    }
                } rightBtnAction: {
                    withAnimation {
                        showingSettings = true
                    }
                }

                ScrollViewReader { proxy in
                    ScrollView(.vertical) {
                        LazyVStack {
                            ForEach(viewModel.messages, id: \.id) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                        .onChange(of: viewModel.messages.count, perform: { _ in
                            // 自动滚动到底部
                            scrollToBottom(in: proxy)
                        })
//                        .debugBorder(.blue)
                    }
                    .debugBorder(.red)
                }

                // 聊天输入框
                HStack {
                    Button {
                        // TODO: 上传照片
                    } label: {
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(.black)
                            .padding(.leading, 21)
                    }

                    TextField("输入消息...", text: $messageText)
                        .foregroundColor(.gray)
                        .textFieldStyle(.plain)
                        .disabled(viewModel.isLoading)

                    Spacer()

                    Button(action: {
                        sendMessage()
                    }) {
//                        Image(systemName: "arrow.up.circle")
                        Image(systemName: "paperplane.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(45))
                            .padding(10)
                            .background(Color(hex: "413159"))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 13)
                    .disabled(viewModel.isLoading || messageText.isEmpty)
                }
                .padding(.vertical, 12)
                // 悬浮效果
                .background(
                    ZStack {
                        // 底层阴影
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)

                        // 渐变边框
                        RoundedRectangle(cornerRadius: 40)
                            .strokeBorder(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 1
                            )
                    }
                )
                .padding(.horizontal)
//                .debugBorder(.yellow)
            }
            .padding(.bottom)
            .ignoresSafeArea(edges: [.bottom])
            .onAppear {
                viewModel.loadCharacter(for: characterId)
                guard let conversationId = viewModel.currentCharacter.conversations.sorted(by: { $0.updatedAt > $1.updatedAt }).first?.id else { return }
                viewModel.loadConversation(for: conversationId)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("AI 思考中...")
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(20)
                        .shadow(radius: 5)
                }
            }
            .alert("Error", isPresented: Binding(get: { viewModel.errorMessage != nil }, set: { if !$0 { viewModel.errorMessage = nil } })) {
                Button("Confirm", role: .cancel) {}
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }

            // MARK: 左侧抽屉(侧边栏)

            GeometryReader { geometry in

                HStack(spacing: 0) {
                    if showingConversationList {
                        // 侧边栏内容
                        VStack {
                            ConversationListView(character: viewModel.currentCharacter) {
                                withAnimation(.spring()) {
                                    showingConversationList = false
                                }
                            } setRoleName: { newRoleName in
                                viewModel.updateCharacterName(newRoleName)
                            } setConversationName: { newConversationName in
                                viewModel.updateConversationTitle(newConversationName)
                            } chooseConversation: { conversationId in
                                viewModel.loadConversation(for: conversationId)
                            } createNewConversation: {
                                viewModel.createNewConversation()
                            } deleteConversation: { conversationId in
                                viewModel.deleteConversation(id: conversationId)
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .transition(.move(edge: .leading))
                        .background(Color(.systemBackground))
                        .debugBorder(.green)

                        // 半透明背景，当侧边栏显示时用来关闭侧边栏
                        Color.white.opacity(0.1)
                            .debugBorder(.red)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation {
                                    showingConversationList = false
                                }
                            }
                    }
                }
            }

            // MARK: 右侧抽屉(参数设置)

            GeometryReader { geometry in
                HStack(spacing: 0) {
                    if showingSettings {
                        // 侧边栏内容
                        VStack {
                            CharacterSettingsView(character: viewModel.currentCharacter) {
                                withAnimation {
                                    showingSettings = false
                                }
                            } save: { character in
                                viewModel.updateCharacterSettings(character.settings)
                                withAnimation {
                                    showingSettings = false
                                }
                            }
                        }
                        .frame(height: geometry.size.height)
                        .transition(.move(edge: .trailing))
                        .background(Color(.systemBackground))
                        .debugBorder(.green)
                    }
                }
            }
        }
        .onDisappear {
            showingConversationList = false
            showingSettings = false
        }
    }

    func scrollToBottom(in proxy: ScrollViewProxy) {
        if let lastMessageId = viewModel.messages.last?.id {
            withAnimation {
                proxy.scrollTo(lastMessageId, anchor: .bottom)
            }
        }
    }

    func sendMessage() {
        guard !messageText.isEmpty else { return }

        let content = messageText
        messageText = ""

        Task {
            await viewModel.sendMessage(content)
        }
    }

    func uploadPhotos() {}
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

#Preview {
    ChatView(characterId: PreviewData.mockCharacters[0].id, conversationId: PreviewData.mockCharacters[0].conversations[0].id)
}
