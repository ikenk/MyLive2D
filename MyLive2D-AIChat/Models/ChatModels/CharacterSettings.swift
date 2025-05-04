//
//  CharacterSettings.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

/// 角色的设置参数集合
///
/// 包含与角色相关的所有配置选项，如大语言模型参数、
/// 语音合成参数以及系统提示词等。
///
/// - Note: 这些设置影响角色的行为和响应方式
struct CharacterSettings: Codable {
    // MARK: - 属性
    
    /// LMStudio大型语言模型的相关参数
    /// 控制文本生成的行为和质量
    var modelParameters: LMStudioParameters
    
    /// GPT-SoVITS语音合成的相关参数
    /// 用于文本转语音的配置，可选
    var voiceParameters: GPTSoVITSParameters?
    
    /// 用户自定义的系统提示词
    /// 设定角色的基本行为和人设
    var systemPrompt: String?
}
