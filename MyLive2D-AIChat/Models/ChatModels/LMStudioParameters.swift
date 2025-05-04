//
//  LMStudioParameters.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

/// LMStudio大型语言模型的参数配置
///
/// 这些参数控制语言模型生成文本的行为和特性，
/// 包括使用的模型、温度、最大令牌数和是否使用流式输出等。
struct LMStudioParameters: Codable {
    // MARK: - 属性
    
    /// 使用的模型名称
    /// 例如："deepseek-r1-distill-qwen-1.5b"
    var model: String
    
    /// 温度参数，控制输出的随机性
    /// 值越高，回复越随机创新；值越低，回复越确定和保守
    /// 通常在0.0到1.0之间，默认值通常为0.7
    var temperature: Float
    
    /// 最大生成的token数
    /// 限制回复的长度，-1表示不限制
    var maxTokens: Int
    
    /// 是否使用流式输出
    /// 启用后可逐字接收模型生成的内容
    var stream: Bool
    
    // 其他可能的参数...
}
