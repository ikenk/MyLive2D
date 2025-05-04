//
//  CustomNavigationBar.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/25.
//

import SwiftUI

struct CustomNavigationBar<LeftIcon: View, RightIcon: View>: View {
    let characterName: String
    let conversationTitle: String
    
    let leftIcon: LeftIcon?
    let rightIcon: RightIcon?
    let leftBtnAction: (()->Void)?
    let rightBtnAction: (()->Void)?
    
    init(characterName: String = "",
         conversationTitle: String = "",
         leftIcon: LeftIcon? = nil,
         rightIcon: RightIcon? = nil,
         leftBtnAction: (()->Void)? = nil,
         rightBtnAction: (()->Void)? = nil)
    {
        self.characterName = characterName
        self.conversationTitle = conversationTitle
        
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.leftBtnAction = leftBtnAction
        self.rightBtnAction = rightBtnAction
    }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                Button {
                    leftBtnAction?()
                } label: {
                    leftIcon
                        .font(.system(size: 22))
                        .frame(height: 44)
                }
                .debugBorder(.cyan)
                    
                Spacer()
                    
                VStack {
                    if(!conversationTitle.isEmpty){
                        Text(characterName)
                            .font(.headline)
                            .lineLimit(1)
                        Text(conversationTitle)
                            .font(.subheadline)
                            .lineLimit(1)
                    }else{
                        Text(characterName)
                            .font(.title)
                            .lineLimit(1)
                    }
                }
//                .padding(.horizontal, 16)
//                .background(Color.black.opacity(0.15))
//                .cornerRadius(12)
                .frame(maxWidth: geometry.size.width * 0.5)
                .debugBorder(.cyan)
                    
                Spacer()
                    
                Button {
                    rightBtnAction?()
                } label: {
                    rightIcon
                        .font(.system(size: 22))
                        .frame(height: 44)
                }
                .debugBorder(.cyan)
            }
            .padding(.horizontal)
            .frame(height: 44)
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(key: SafeAreaInsetsKey.self, value: geometry.safeAreaInsets)
                }
            )
//            .background(Color(.systemBackground))
            .background(.white.opacity(0))
//            .debugBorder()
        }
        .frame(height: 44)
    }
}

#Preview {
    CustomNavigationBar(
        characterName: "新角色",
        conversationTitle: "新对话",
        leftIcon: Image(systemName: "square.grid.2x2")
            .foregroundColor(.black.opacity(0.7))
            .font(.system(size: 20))
            .frame(width: 40, height: 40)
            .background(Color.black.opacity(0.15))
            .cornerRadius(12),
        rightIcon: Image(systemName: "bell.fill")
            .foregroundColor(.black.opacity(0.7))
            .font(.system(size: 20))
            .frame(width: 40, height: 40)
            .background(Color.black.opacity(0.15))
            .cornerRadius(12)
    )
}
