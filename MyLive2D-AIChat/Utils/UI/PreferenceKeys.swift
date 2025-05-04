//
//  PreferenceKeys.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/25.
//

import SwiftUI

// 创建一个PreferenceKey来获取SafeArea高度
struct SafeAreaInsetsKey: PreferenceKey {
    static var defaultValue: EdgeInsets = EdgeInsets()
    
    static func reduce(value: inout EdgeInsets, nextValue: () -> EdgeInsets) {
        value = nextValue()
    }
}
