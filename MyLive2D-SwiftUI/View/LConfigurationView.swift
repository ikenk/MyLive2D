//
//  ContentView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/11/17.
//

import PhotosUI
import RealityKit
import SwiftUI

struct LConfigurationView: View {
    @EnvironmentObject var modelManager: LModelManager

//    @State private var sceneIndex: Int = 0

    @State private var modelParameter: ModelParameter = .init()

    @State var imageSelection: PhotosPickerItem? = nil

    @State var isLoading: Bool = false

    var body: some View {
        ScrollView(.vertical) {
            Text("Configuration Panel")
                .font(.title)

            Button {
                My_LAppLive2DManager.shared().nextScene()
            } label: {
                Text("Next Model")
                    .font(.title2)
                    .foregroundStyle(.indigo)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.purple, lineWidth: 1)
            )
            .padding(.horizontal, 10)

            Button {
                My_LAppLive2DManager.shared().previousScene()
            } label: {
                Text("Previous Model")
                    .font(.title2)
                    .foregroundStyle(.indigo)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.purple, lineWidth: 1)
            )
            .padding(.horizontal, 10)

            Toggle("Anime Autoplayed Switch", isOn: $modelManager.isGlobalAutoplayed)
                .padding(10)
                .foregroundStyle(.indigo)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(.purple, lineWidth: 1)
                )
                .padding(.horizontal, 10)
                .onChange(of: modelManager.isGlobalAutoplayed) { newValue in
                    My_LAppLive2DManager.shared().setModelMotionGlobalAutoplayed(newValue)
                }

            HStack(spacing: 5) {
                PhotosPicker(selection: $imageSelection, matching: createPhotosFilter(), preferredItemEncoding: .compatible) {
                    Text("Pick a Image")
                        .font(.title2)
                        .foregroundStyle(.indigo)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(.purple, lineWidth: 1)
                        )
                        .padding(.horizontal, 10)
                }
                .onChange(of: imageSelection) { newValue in
                    guard let item = newValue else { return }
                    isLoading = true

                    Task {
                        do {
                            guard let imageData = try await item.loadTransferable(type: Data.self) else { return }

                            guard let uiImage = UIImage(data: imageData) else { return }

                            guard let pngData = uiImage.pngData() else { return }

                            let rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                            let resourcePath = rootURL.appending(path: "Resources", directoryHint: .isDirectory)
                            let filePath = resourcePath.appending(path: "back_class_normal", directoryHint: .notDirectory).appendingPathExtension("png")
                            print("[MyLog]PhotosPicker filePath: \(filePath)")

//                            try imageData.write(to: filePath)
                            try pngData.write(to: filePath)

                            My_ViewControllerBridge.shared().setBackgroundImage()

                            await MainActor.run {
                                isLoading = false
                            }
                        } catch {
                            await MainActor.run {
                                isLoading = false
                            }
                            print("[MyLog]PhotosPicker Error: \(error)")
                        }
                    }
                }

                if isLoading {
                    ProgressView()
                }
            }

            Group {
                VStack(spacing: 5) {
                    Text("X Translation")
                        .foregroundStyle(.primary)

                    Slider(value: $modelParameter.xTranslation, in: -Float(UIScreen.main.bounds.width) / Float(UIScreen.main.bounds.height) ... Float(UIScreen.main.bounds.width) / Float(UIScreen.main.bounds.height)) {
                        Text("X Translation")
                            .foregroundStyle(.primary)
                    } minimumValueLabel: {
                        Text("\((-Float(UIScreen.main.bounds.width) / 2).formatted(.number.precision(.fractionLength(0))))")
                            .font(.callout)
                    } maximumValueLabel: {
                        Text("\((Float(UIScreen.main.bounds.width) / 2).formatted(.number.precision(.fractionLength(0))))")
                            .font(.callout)
                    }
                    .onChange(of: modelParameter.xTranslation) { newValue in
                        print("[MyLog]modelParameter.xTranslation: \(newValue)")
                        My_LAppLive2DManager.shared().setModelPositionOnX(newValue)
                    }
                }

                VStack(spacing: 5) {
                    Text("Y Translation")
                        .foregroundStyle(.primary)

                    Slider(value: $modelParameter.yTranslation, in: -1 ... 1) {
                        Text("Y Translation")
                            .foregroundStyle(.primary)
                    } minimumValueLabel: {
                        Text("\((-Float(UIScreen.main.bounds.height) / 2).formatted(.number.precision(.fractionLength(0))))")
                            .font(.callout)
                    } maximumValueLabel: {
                        Text("\((Float(UIScreen.main.bounds.height) / 2).formatted(.number.precision(.fractionLength(0))))")
                            .font(.callout)
                    }
                    .onChange(of: modelParameter.yTranslation) { newValue in
                        print("[MyLog]modelParameter.yTranslation: \(newValue)")
                        My_LAppLive2DManager.shared().setModelPositionOnY(newValue)
                    }
                }

                VStack(spacing: 5) {
                    Text("Scale")
                        .foregroundStyle(.primary)

                    Slider(value: $modelParameter.scale, in: 1 ... 3) {
                        Text("Scale")
                            .foregroundStyle(.primary)
                    } minimumValueLabel: {
                        Text("1")
                            .font(.callout)
                    } maximumValueLabel: {
                        Text("2")
                            .font(.callout)
                    }
                    .onChange(of: modelParameter.scale) { newValue in
                        print("[MyLog]modelParameter.scale: \(newValue)")
                        My_LAppLive2DManager.shared().setModelScale(x: newValue, y: newValue)
                    }
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.purple, lineWidth: 1)
            )
            .padding(.horizontal, 10)
        }
    }
}

extension LConfigurationView {
    func createPhotosFilter() -> PHPickerFilter {
        var filters: [PHPickerFilter] = [
            .bursts,
            .cinematicVideos,
            .depthEffectPhotos,
            .livePhotos,
            .panoramas,
            .screenRecordings,
            .slomoVideos,
            .timelapseVideos,
            .videos,
        ]

        if #available(iOS 18.0, *) {
            filters.append(.spatialMedia)
        }

        return .not(.any(of: filters))
    }
}

// #Preview {
//    ContentView()
// }

struct ModelParameter {
    var xTranslation: Float = .zero
    var yTranslation: Float = .zero
    var scale: Float = .zero
    var rotation: Float = .zero
}
