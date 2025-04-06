//
//  CharacterSettings.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/05.
//
import Foundation

struct CharacterSettings: Codable {
    var modelParameters: LMStudioParameters  // LMStudio模型参数
    var voiceParameters: GPTSoVITSParameters?  // 预留的语音参数
}
