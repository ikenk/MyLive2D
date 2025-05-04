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

    @EnvironmentObject var viewManager: LViewManager

    @State private var lPickImageViewHeight: CGFloat = 0

//    @State private var sceneIndex: Int = 0

//    @State private var modelParameter: ModelParameter = .init()
//
//    @State var imageSelection: PhotosPickerItem? = nil
//
//    @State var isLoading: Bool = false

    var body: some View {
//        ScrollView(.vertical) {
        ////            Text("Configuration Panel")
        ////                .font(.title)
        ////                .foregroundStyle(.primary)
        ////                .padding(.top, 15)
//
//
//
//
        ////            Toggle("Anime Autoplay", isOn: $modelManager.isGlobalAutoplayed)
        ////                .padding(10)
        ////                .foregroundStyle(.primary)
        ////                .overlay(
        ////                    RoundedRectangle(cornerRadius: 10)
        ////                        .strokeBorder(.purple, lineWidth: 1)
        ////                )
        ////                .padding(.horizontal, 10)
        ////                .onChange(of: modelManager.isGlobalAutoplayed) { newValue in
        ////                    My_LAppLive2DManager.shared().setModelMotionGlobalAutoplayed(newValue)
        ////                }
//
        ////            Toggle(isOn: $modelManager.isGlobalAutoplayed) {
        ////                Text("Anime Autoplay")
        ////                    .font(.title2)
        ////                    .padding(.leading,10)
        ////            }
        ////            .padding(10)
        ////            .overlay(
        ////                RoundedRectangle(cornerRadius: 10)
        ////                    .strokeBorder(.purple, lineWidth: 1)
        ////            )
        ////            .padding(.horizontal, 10)
        ////            .onChange(of: modelManager.isGlobalAutoplayed) { newValue in
        ////                My_LAppLive2DManager.shared().setModelMotionGlobalAutoplayed(newValue)
        ////            }
//
        ////            HStack(spacing: 5) {
        ////                PhotosPicker(selection: $imageSelection, matching: createPhotosFilter(), preferredItemEncoding: .compatible) {
        ////                    Text("Select Background")
        ////                        .font(.title2)
        ////                        .tint(.primary)
        ////                        .frame(maxWidth: .infinity)
        ////                        .padding()
        ////                        .overlay(
        ////                            RoundedRectangle(cornerRadius: 10)
        ////                                .strokeBorder(.purple, lineWidth: 1)
        ////                        )
        ////                        .padding(.horizontal, 10)
        ////                }
        ////                .onChange(of: imageSelection) { newValue in
        ////                    guard let item = newValue else { return }
        ////                    isLoading = true
        ////
        ////                    Task {
        ////                        do {
        ////                            guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        ////
        ////                            guard let uiImage = UIImage(data: imageData) else { return }
        ////
        ////                            guard let pngData = uiImage.pngData() else { return }
        ////
        ////                            let rootURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        ////                            let resourcePath = rootURL.appending(path: "Resources", directoryHint: .isDirectory)
        ////                            let filePath = resourcePath.appending(path: "back_class_normal", directoryHint: .notDirectory).appendingPathExtension("png")
        ////                            print("[MyLog]PhotosPicker filePath: \(filePath)")
        ////
        //////                            try imageData.write(to: filePath)
        ////                            try pngData.write(to: filePath)
        ////
        ////                            My_ViewControllerBridge.shared().setBackgroundImage()
        ////
        ////                            await MainActor.run {
        ////                                isLoading = false
        ////                            }
        ////                        } catch {
        ////                            await MainActor.run {
        ////                                isLoading = false
        ////                            }
        ////                            print("[MyLog]PhotosPicker Error: \(error)")
        ////                        }
        ////                    }
        ////                }
        ////
        ////                if isLoading {
        ////                    ProgressView()
        ////                }
        ////            }
//
        ////            Group {
        ////                VStack(spacing: 5) {
        ////                    Text("X Translation")
        ////                        .foregroundStyle(.primary)
        ////
        ////                    Slider(value: $modelParameter.xTranslation, in: -Float(UIScreen.main.bounds.width) / Float(UIScreen.main.bounds.height) ... Float(UIScreen.main.bounds.width) / Float(UIScreen.main.bounds.height)) {
        ////                        Text("X Translation")
        ////                    } minimumValueLabel: {
        //////                        Text("\((-Float(UIScreen.main.bounds.width) / 2).formatted(.number.precision(.fractionLength(0))))")
        //////                            .font(.callout)
        ////                        Text("Left")
        ////                            .font(.callout)
        ////                    } maximumValueLabel: {
        //////                        Text("\((Float(UIScreen.main.bounds.width) / 2).formatted(.number.precision(.fractionLength(0))))")
        //////                            .font(.callout)
        ////                        Text("Right")
        ////                            .font(.callout)
        ////                    }
        ////                    .onChange(of: modelParameter.xTranslation) { newValue in
        ////                        print("[MyLog]modelParameter.xTranslation: \(newValue)")
        ////                        My_LAppLive2DManager.shared().setModelPositionOnX(newValue)
        ////                    }
        ////                }
        ////
        ////                VStack(spacing: 5) {
        ////                    Text("Y Translation")
        ////                        .foregroundStyle(.primary)
        ////
        ////                    Slider(value: $modelParameter.yTranslation, in: -1 ... 1) {
        ////                        Text("Y Translation")
        ////                    } minimumValueLabel: {
        //////                        Text("\((-Float(UIScreen.main.bounds.height) / 2).formatted(.number.precision(.fractionLength(0))))")
        //////                            .font(.callout)
        ////                        Text("Down")
        ////                            .font(.callout)
        ////                    } maximumValueLabel: {
        //////                        Text("\((Float(UIScreen.main.bounds.height) / 2).formatted(.number.precision(.fractionLength(0))))")
        //////                            .font(.callout)
        ////                        Text("Up")
        ////                            .font(.callout)
        ////                    }
        ////                    .onChange(of: modelParameter.yTranslation) { newValue in
        ////                        print("[MyLog]modelParameter.yTranslation: \(newValue)")
        ////                        My_LAppLive2DManager.shared().setModelPositionOnY(newValue)
        ////                    }
        ////                }
        ////
        ////                VStack(spacing: 5) {
        ////                    Text("Scale")
        ////                        .foregroundStyle(.primary)
        ////
        ////                    Slider(value: $modelParameter.scale, in: 1 ... 3) {
        ////                        Text("Scale")
        ////                    } minimumValueLabel: {
        ////                        Text("1")
        ////                            .font(.callout)
        ////                    } maximumValueLabel: {
        ////                        Text("3")
        ////                            .font(.callout)
        ////                    }
        ////                    .onChange(of: modelParameter.scale) { newValue in
        ////                        print("[MyLog]modelParameter.scale: \(newValue)")
        ////                        My_LAppLive2DManager.shared().setModelScale(x: newValue, y: newValue)
        ////                    }
        ////                }
        ////            }
        ////            .padding()
        ////            .overlay(
        ////                RoundedRectangle(cornerRadius: 10)
        ////                    .strokeBorder(.purple, lineWidth: 1)
        ////            )
        ////            .padding(.horizontal, 10)
        ////            .padding(.bottom, 10)
//        }

//        if viewManager.isShowLConfigurationView {
        //        VStack {
        //            Text("Configuration Panel")
        //                .font(.title)
        //                .foregroundStyle(.primary)
        //                .padding(.top, 15)

//        List {
//            LChangeModelView()
//                .listRowBackground(Color.clear)
//
//            LAnimationControllerView()
//                .listRowBackground(Color.clear)
//
//            LPickImageView()
//                .listRowBackground(Color.clear)
//
//            LSliderView()
//                .listRowBackground(Color.clear)
//        }
//        .listStyle(.plain)

        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 10) {
                    settingsCard(title: "Change Models") {
                        LChangeModelView()
                    }

                    settingsCard(title: "Play Animation") {
                        LAnimationControllerView()
                    }
                }

                HStack(alignment: .top, spacing: 10) {
                    settingsCard(title: "Pick a Image", alignment: .center) {
                        LPickImageView()
                    }
                    .background(
                        GeometryReader(content: { proxy in
                            Color.clear
                                .onAppear {
                                    lPickImageViewHeight = proxy.size.height
                                }
                        })
                    )

                    //                    let _ = MyLog("viewManager.isShowLARFaceTrackingView", viewManager.isShowLARFaceTrackingView)
                    //                    let _ = MyLog("lPickImageViewHeight", lPickImageViewHeight)

                    if lPickImageViewHeight > 0 && viewManager.isShowLARFaceTrackingView {
                        LARFaceTrackingView()
                            .aspectRatio(1.0, contentMode: .fit)
                            .frame(height: lPickImageViewHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 30))
                        //                            .onAppear {
                        //                                MyLog("LARFaceTrackingView 出现")
                        //                            }
                    }
                }

                settingsCard(title: "Change Model Config") {
                    LSliderView()
                }
            }
            .padding(15)
        }
        .scrollIndicators(.hidden)
        .contentShape(Rectangle())
        //        }
//        }
    }
}

extension LConfigurationView {
//    func createPhotosFilter() -> PHPickerFilter {
//        var filters: [PHPickerFilter] = [
//            .bursts,
//            .cinematicVideos,
//            .depthEffectPhotos,
//            .livePhotos,
//            .panoramas,
//            .screenRecordings,
//            .slomoVideos,
//            .timelapseVideos,
//            .videos,
//        ]
//
//        if #available(iOS 18.0, *) {
//            filters.append(.spatialMedia)
//        }
//
//        return .not(.any(of: filters))
//    }
}
