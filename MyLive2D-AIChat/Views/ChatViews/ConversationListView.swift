//
//  ConversationListView.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/23.
//

import SwiftUI

struct ConversationListView: View {
    let character: Character
    
    @State private var showingSetRoleName = false
    @State private var showingDeleteConfirm = false
    @State private var showingSetConversationName = false
    @State private var isPressed: Bool = false
    
    @State private var newRoleName = ""
    @State private var newConversationName = ""
    @State private var selectedConversationId: UUID = .init()
    
    var backToChatView: () -> Void
    var setRoleName: (_ newRoleName: String) -> Void
    var setConversationName: (_ newConversationName: String) -> Void
    var chooseConversation: (_ conversationId: UUID) -> Void
    var createNewConversation: () -> Void
    var deleteConversation: (_ conversationId: UUID) -> Void
    
    var body: some View {
        ZStack {
            // 背景色
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 自定义导航栏
                CustomNavigationBar(
                    characterName: character.name,
                    leftIcon: Image(systemName: "chevron.left")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.title2)
                        .frame(width: 40, height: 40)
                        .cornerRadius(12),
                    rightIcon: Image(systemName: "square.and.pencil")
                        .foregroundColor(.black.opacity(0.7))
                        .font(.title)
                        .frame(width: 40, height: 40)
                        .cornerRadius(12)
                ) {
                    // 返回操作
                    backToChatView()
                } rightBtnAction: {
                    showingSetRoleName = true
                }
                
                // 对话列表
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(character.conversations.sorted(by: { $0.updatedAt > $1.updatedAt }), id: \.id) { conversation in
                            conversationCard(conversation)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .scrollIndicators(.hidden)
                
                Button {
                    createNewConversation()
                    backToChatView()
                } label: {
                    HStack {
                        Image(systemName: "plus.circle")
                        
                        Text("添加对话")
                    }
                    .font(.title2)
                    .foregroundStyle(.black.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .backgroundShadow(cornerRadius: 20, blurRadius: 2, shadowOffset: CGSize(width: 0, height: 3))
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .alert("修改角色名称", isPresented: $showingSetRoleName) {
            TextField("角色名称", text: $newRoleName)
            Button("取消", role: .cancel) { newRoleName = "" }
            Button("修改") {
                if newRoleName.isEmpty { return }
                setRoleName(newRoleName)
                backToChatView()
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

extension ConversationListView {
    @ViewBuilder
    private func conversationCard(_ conversation: Conversation) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // 对话标题和消息计数
            HStack {
                HStack(alignment: .firstTextBaseline) {
                    Text(conversation.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .border(.red)
                    
                    Button(action: {
                        showingSetConversationName = true
                    }, label: {
                        Image(systemName: "square.and.pencil")
                            .font(.headline)
                            .foregroundColor(.black.opacity(0.7))
                    })
                    .border(.yellow)
                }
                    
                Spacer()
                    
                Text("\(conversation.messages.count)条消息")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
            }
                
            // 最后一条消息预览
            if let lastMessage = conversation.messages.last {
                Text(lastMessage.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .padding(.top, 4)
            }
                
            // 更新时间和删除按钮
            HStack {
                Text(formattedDate(conversation.updatedAt))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    
                Spacer()
                    
                Button {
                    showingDeleteConfirm = true
                    
                } label: {
                    Image(systemName: "trash")
                        .font(.caption)
                        .foregroundColor(.red.opacity(0.7))
                }
            }
        }
        .padding(16)
        .backgroundShadow(cornerRadius: 30, blurRadius: 8, shadowOffset: CGSize(width: 0, height: 4))
        // 添加灰色遮罩和下沉效果
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.black.opacity(isPressed && selectedConversationId == conversation.id ? 0.05 : 0))
        )
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                        selectedConversationId = conversation.id
                        chooseConversation(conversation.id)
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                        backToChatView()
                    }
                }
        )
        .alert("确认要删除对话吗？", isPresented: $showingDeleteConfirm) {
            Button("取消", role: .cancel) {}
            Button("确认") {
                // 删除操作
                deleteConversation(conversation.id)
            }
        }
        .alert("修改对话名称", isPresented: $showingSetConversationName) {
            TextField("对话名称", text: $newConversationName)
            Button("取消", role: .cancel) { newConversationName = "新对话" }
            Button("修改") {
                if newConversationName.isEmpty { return }
                setConversationName(newConversationName)
                backToChatView()
            }
        }
    }
}

#Preview {
    ConversationListView(character: PreviewData.mockCharacters[0], backToChatView: {}, setRoleName: { _ in }, setConversationName: { _ in }, chooseConversation: { _ in }, createNewConversation: {}, deleteConversation: { _ in })
}
