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
    @State private var messageText = ""
    
    @State private var messages:[Message] = PreviewData.mockCharacters[0].conversations[0].messages

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVStack {
                        ForEach(messages,id: \.id) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                    .onChange(of: messages.count, perform: { _ in
                        scrollToBottom(in:proxy)
                    })
                    .border(.blue)
                }
                .border(.red)
            }
            
            HStack{
                TextField("输入消息...",text: $messageText)
                    .border(.green)
            }
            .border(.)
        }
        .navigationTitle(PreviewData.mockCharacters[0].conversations[0].title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func scrollToBottom(in proxy:ScrollViewProxy){
        
    }
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
    NavigationView {
        ChatView(characterId: PreviewData.mockCharacters[0].id, conversationId: PreviewData.mockCharacters[0].conversations[0].id)
    }
}
