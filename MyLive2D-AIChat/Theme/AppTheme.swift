//
//  AppTheme.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/24.
//

import SwiftUI

struct AppTheme {
    let primaryColor: Color
    let secondaryColor: Color
    let backgroundColor: Color
    let accentColor: Color
    
    struct Button {}
    
    struct TextField {}
    
    // 预定义主题
    static let defaultTheme = AppTheme(
        primaryColor: Color.blue,
        secondaryColor: Color.gray,
        backgroundColor: Color.white,
        accentColor: Color.orange
    )
    
    static let darkTheme = AppTheme(
        primaryColor: Color.blue,
        secondaryColor: Color.gray,
        backgroundColor: Color.black,
        accentColor: Color.orange
    )
}
