//
//  Debug.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/17.
//

func MyLog(_ message: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    print("[MyLog][\(file):\(line)] \(function) - \(message): \(items)")
    #endif
}
