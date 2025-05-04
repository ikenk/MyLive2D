//
//  Debug.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/17.
//

func MyLog(_ message: String, _ items: Any..., file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    let projectName = "MyLive2D-SwiftUI"
    let itemsString = items.isEmpty ? "" : ": \(items)"
    let fileDir = file.split(separator: projectName).last ?? "没有该文件路径"
    print("[MyLog][\(fileDir):\(line)] \(function) - \(message)\(itemsString)")
    #endif
}
