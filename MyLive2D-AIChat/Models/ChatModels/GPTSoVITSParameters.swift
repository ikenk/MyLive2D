//
//  GPTSoVITSParameters.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

/// GPT-SoVITS语音合成系统的参数
///
/// 包含控制语音合成的各种参数，如音色、语速、音量等。
/// 这些参数决定了生成语音的特性和质量。
///
/// - Note: 当前为空实现，未来可根据GPT-SoVITS的API扩展
struct GPTSoVITSParameters: Codable{
    // MARK: - 未来可能的属性
    
    // var speaker: String      // 说话人/音色
    // var speed: Float         // 语速
    // var volume: Float        // 音量
    // var pitch: Float         // 音调
    // var audioFormat: String  // 音频格式
}
