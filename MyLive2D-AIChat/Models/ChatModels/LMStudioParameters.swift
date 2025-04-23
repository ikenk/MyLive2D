//
//  LMStudioParameters.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

struct LMStudioParameters: Codable {
    var model: String       // 模型名称，如"deepseek-r1-distill-qwen-1.5b"
    var temperature: Float  // 温度参数，控制输出的随机性，如0.7
    var maxTokens: Int     // 最大token数，-1表示不限制
    var stream: Bool       // 是否使用流式输出
    // 其他可能的参数...
}
