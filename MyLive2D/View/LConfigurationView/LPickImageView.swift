//
//  PickImageView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/18.
//

import PhotosUI
import SwiftUI

struct LPickImageView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State var imageSelection: PhotosPickerItem? = nil

    @State var isLoading: Bool = false

    var body: some View {
//        HStack(spacing: 5) {
//            PhotosPicker(selection: .constant(nil), matching: PHPickerFilter.bursts, preferredItemEncoding: .compatible) {
//                Image(systemName: "photo.stack")
//                    .font(.system(size: 33))
//                    .frame(width: 44, height: 44)
//                    .foregroundStyle(.primary)
//                    .padding()
//                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                    .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
//            }
//            .onChange(of: imageSelection) { newValue in
//                guard let item = newValue else { return }
//                isLoading = true
//
//                Task {
//                    do {
//                        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
//
//                        guard let uiImage = UIImage(data: imageData) else { return }
//
//                        guard let pngData = uiImage.pngData() else { return }
//
//                        let rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//                        let resourcePath = rootURL.appending(path: "Resources", directoryHint: .isDirectory)
//                        let filePath = resourcePath.appending(path: "back_class_normal", directoryHint: .notDirectory).appendingPathExtension("png")
////                            print("[MyLog]PhotosPicker filePath: \(filePath)")
//                        MyLog("PhotosPicker filePath", filePath)
//
//                        //                            try imageData.write(to: filePath)
//                        try pngData.write(to: filePath)
//
//                        My_ViewControllerBridge.shared().setBackgroundImage()
//
//                        await MainActor.run {
//                            isLoading = false
//                        }
//                    } catch {
//                        await MainActor.run {
//                            isLoading = false
//                        }
////                            print("[MyLog]PhotosPicker Error: \(error)")
//                        MyLog("PhotosPicker Error", error)
//                    }
//                }
//            }
//
//            if isLoading {
//                ProgressView()
//            }
//        }
        
        ZStack {
            PhotosPicker(selection: .constant(nil), matching: PHPickerFilter.bursts, preferredItemEncoding: .compatible) {
                Image(systemName: "photo.stack")
                    .font(.system(size: 33))
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.primary)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
            }
            .disabled(isLoading)
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
//                            print("[MyLog]PhotosPicker filePath: \(filePath)")
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
//                            print("[MyLog]PhotosPicker Error: \(error)")
                        MyLog("PhotosPicker Error", error)
                    }
                }
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(DarkModeProgressViewStyle())
            }
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
