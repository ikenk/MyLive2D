//
//  CharacterSettingsView.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/04/24.
//

import SwiftUI

struct CharacterSettingsView: View {
    let character: Character
    
    @State private var serverAddress: String
    @State private var serverPort: String
    @State private var modelName: String
    @State private var temperature: Float
    @State private var maxTokens: Float
    @State private var isStreamOn: Bool = false
    @State private var systemPrompt: String
    
    let cancel: ()->Void
    let save: (_ character: Character)->Void
    
    @State private var sliderBarLength: Double = 0
    @State private var sliderOffset: Double = 0
    
    init(
        character: Character,
        cancel: @escaping ()->Void,
        save: @escaping (_ character: Character)->Void
    ) {
        self.character = character
        
        _serverAddress = .init(initialValue: UserDefaults.standard.string(forKey: UserDefaultsKeys.serverAddress) ?? ServerDefaults.address)
        _serverPort = .init(initialValue: UserDefaults.standard.string(forKey: UserDefaultsKeys.serverPort) ?? ServerDefaults.port)
        
        _modelName = .init(initialValue: character.settings.modelParameters.model)
        _temperature = .init(initialValue: character.settings.modelParameters.temperature)
        _maxTokens = .init(initialValue: Float(character.settings.modelParameters.maxTokens))
        _systemPrompt = .init(initialValue: character.settings.systemPrompt ?? "")
        
        self.cancel = cancel
        self.save = save
    }
    
    var body: some View {
        VStack {
            CustomNavigationBar(
                characterName: character.name,
                leftIcon: Image(systemName: "chevron.left")
                    .foregroundColor(.black.opacity(0.7))
                    .font(.title)
                    .frame(width: 40, height: 40)
                    .cornerRadius(12),
                rightIcon: Image(.save)
                    .resizable()
                    .scaleEffect(0.9)
                    .foregroundColor(.black.opacity(0.7))
                    .frame(width: 40, height: 40)
                    .cornerRadius(12)
            ) {
                cancel()
            } rightBtnAction: {
                saveSettings()
            }
            
            // 主要内容区域
            ScrollView {
                VStack(spacing: 15) {
                    // 服务器设置卡片
                    settingsCard(title: "服务器设置") {
                        VStack(spacing: 16) {
                            inputField(title: "服务器地址", text: $serverAddress, keyboardType: .URL)
                            inputField(title: "端口", text: $serverPort, keyboardType: .numberPad)
                        }
                    }

                    // 模型参数卡片
                    settingsCard(title: "模型参数") {
                        inputField(title: "模型名称", text: $modelName)
                        
                        // 温度滑块
                        CustomSlider(sliderVariant: $temperature, sliderRange: 0 ... 2.0, sliderVariantName: "温度 (Temperature)")
                        
                        // 令牌数滑块
                        CustomSlider(sliderVariant: $maxTokens, sliderRange: -1 ... 16385, sliderVariantName: maxTokens == -1 ? "不限制" : "\(Int(maxTokens))", isInteger: true)
                    }
                    
                    // 系统提示词卡片
                    settingsCard(title: "系统提示词") {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("* 请在首次对话开始前输入提示词")
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.8))
                                .padding(.vertical, 4)
                                                    
                            TextEditor(text: $systemPrompt)
                                .padding(2)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(16)
                                .frame(minHeight: 120)
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.bottom)
            }
            .padding()
            .scrollIndicators(.hidden)
        }
    }
    
    func saveSettings() {
        // 保存服务器设置到UserDefaults
        UserDefaults.standard.set(serverAddress, forKey: UserDefaultsKeys.serverAddress)
        UserDefaults.standard.set(serverPort, forKey: UserDefaultsKeys.serverPort)
        
        // 更新角色设置
        var updatedSettings = character.settings
        updatedSettings.modelParameters = LMStudioParameters(
            model: modelName,
            temperature: temperature,
            maxTokens: Int(maxTokens),
            stream: isStreamOn
        )
        updatedSettings.systemPrompt = systemPrompt
        
        var updatedCharacter = character
        updatedCharacter.settings = updatedSettings
        
        // 调用保存回调
        save(updatedCharacter)
    }
}

extension CharacterSettingsView {
//    // 通用的设置卡片视图
//    @ViewBuilder
//    private func settingsCard<Content: View>(title: String, @ViewBuilder content: ()->Content)->some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text(title)
//                .font(.headline)
//                .fontWeight(.bold)
//                .foregroundStyle(.black)
//
//            content()
//        }
//        .padding(20)
//        .backgroundShadow(cornerRadius: 30, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 4))
//    }
    
    @ViewBuilder
    private func inputField(title: String, text: Binding<String>, keyboardType: UIKeyboardType = .default)->some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.black)
            
            TextField("", text: text)
                .padding(12)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.gray.opacity(0.07), Color.gray.opacity(0.05)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(10)
                .foregroundStyle(.black)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.never)
        }
    }
}

#Preview {
    CharacterSettingsView(character: PreviewData.mockCharacters[0], cancel: {}, save: { _ in })
}
