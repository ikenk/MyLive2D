//
//  View+BackgroundShadow.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/05/01.
//

import SwiftUI

struct BackgroundShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    let cornerRadius: CGFloat
    let blurRadius: CGFloat
    let shadowOffset: CGSize

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    // 底层阴影
                    RoundedRectangle(cornerRadius: cornerRadius)
                        // 保持填充颜色与背景色一致，方便做Dark Mode适配
                        .fill(colorScheme == .light ? .white : .black.opacity(0.9))
                        .background(content: {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color.black.opacity(0.2), Color.black.opacity(0.1)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .blur(radius: blurRadius)
                                .offset(x: shadowOffset.width, y: shadowOffset.height)
                        })

                    // 渐变边框
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: colorScheme == .light ? [Color.gray.opacity(0.3), Color.gray.opacity(0.2)] : [Color.gray.opacity(0.7), Color.gray.opacity(0.5)]),
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                }
            )
        // 直角阴影，无法圆角化
//            .background(
//                ZStack {
//                    // 底层阴影
//                    RoundedRectangle(cornerRadius: 30)
//                        .fill(Color.white)
//                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
//
//                    // 渐变边框
//                    RoundedRectangle(cornerRadius: 30)
//                        .strokeBorder(
//                            LinearGradient(
//                                gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)]),
//                                startPoint: .top,
//                                endPoint: .bottom
//                            ),
//                            lineWidth: 1
//                        )
//                }
//            )
    }
}

extension View {
    func backgroundShadow(cornerRadius: CGFloat, blurRadius: CGFloat, shadowOffset: CGSize) -> some View {
        modifier(BackgroundShadowModifier(cornerRadius: cornerRadius, blurRadius: blurRadius, shadowOffset: shadowOffset))
    }
}
