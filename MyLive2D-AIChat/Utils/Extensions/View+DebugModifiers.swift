//
//  View+DebugModifiers.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/24.
//

import SwiftUI

/// 仅在DEBUG模式下展示的BorderModifier
struct DebugBorderModifier: ViewModifier {
    let color: Color
    let witdh: CGFloat

    func body(content: Content) -> some View {
        #if DEBUG
        content
            .border(color, width: witdh)
        #else
        content
        #endif
    }
}

/// 仅在DEBUG模式下展示的BackgroundModifier
struct DebugBackgroundModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        #if DEBUG
        content
            .background(color)
        #else
        content
        #endif
    }
}

// MARK: - View 扩展

public extension View {
    /// 仅在DEBUG构建中为视图添加边框
    /// - Parameters:
    ///   - color: 调试边框的颜色
    ///   - width: 调试边框的宽度
    /// - Returns: 应用了调试边框的视图
    func debugBorder(_ color: Color = .red, width: CGFloat = 1.0) -> some View {
        modifier(DebugBorderModifier(color: color, witdh: width))
    }

    /// 仅在DEBUG构建中为视图添加背景色
    /// - Parameter color: 调试背景的颜色
    /// - Returns: 应用了调试背景的视图
    func debugBackground(_ color: Color = .yellow.opacity(0.5)) -> some View {
        modifier(DebugBackgroundModifier(color: color))
    }

    /// 在DEBUG构建中打印视图的尺寸
    /// - Parameters:
    ///   - label: 在日志中标识此测量的标签
    ///   - file: 源文件（自动填充）
    ///   - function: 函数名（自动填充）
    ///   - line: 行号（自动填充）
    /// - Returns: 在DEBUG构建中带有尺寸报告的原始视图
    func debugSize(_ label: String = "", file: String = #file, function: String = #function, line: Int = #line) -> some View {
        #if DEBUG
        return background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        let filename = URL(filePath: file, directoryHint: .notDirectory)
                        print("[DebugSize][\(filename):\(line)] \(function) - \(label) 尺寸: \(geometry.size)")
                    }
                    .onChange(of: geometry.size) { newSize in
                        let filename = URL(filePath: file, directoryHint: .notDirectory)
                        print("[DebugSize][\(filename):\(line)] \(function) - \(label) 尺寸变化: \(newSize)")
                    }
            }
        )
        #else
        return self
        #endif
    }
}
