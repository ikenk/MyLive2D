//
//  CustomTabBarModel.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/27.
//

import SwiftUI

enum TabItem: String, CaseIterable {
    case Voice
    case Chat
    case Camera

    var defaultIconName: String {
        switch self {
        case .Chat:
            return "message"
        case .Voice:
            return "microphone"
        case .Camera:
            return "camera"
        }
    }

    var selectedIconName: String {
        switch self {
        case .Chat:
            return "message.fill"
        case .Voice:
            return "microphone.fill"
        case .Camera:
            return "camera.fill"
        }
    }

    var iconNum: CGFloat {
        switch self {
        case .Chat:
            return 1
        case .Voice:
            return 0
        case .Camera:
            return 2
        }
    }
}
