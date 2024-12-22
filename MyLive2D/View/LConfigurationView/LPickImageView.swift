//
//  PickImageView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/18.
//

import SwiftUI
import PhotosUI

struct LPickImageView: View {
    @State var imageSelection: PhotosPickerItem? = nil

    @State var isLoading: Bool = false
    
    var body: some View {
        Section {
            HStack(spacing: 5) {
                PhotosPicker(selection: $imageSelection, matching: createPhotosFilter(), preferredItemEncoding: .compatible) {
                    Text("Choose Image")
                        .font(.title2)
                        .tint(.primary)
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

                            MyLog("PhotosPicker filePath", filePath)

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

                            MyLog("PhotosPicker Error", error)
                        }
                    }
                }

                if isLoading {
                    ProgressView()
                }
            }
        } header: {
            Text("Choose Background Image")
        }
    }
}

extension LPickImageView {
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
