//
//  InfoButton.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/17.
//

import SwiftUI

struct LInfoButton: View {
    @EnvironmentObject var viewManager: LViewManager
    @State var isShow: Bool = false
    var body: some View {
        Button {
//            print("[MyLog]LInfoButton Tap")
            MyLog("LInfoButton Tap")
            if viewManager.isShowLARFaceTrackingView {
                viewManager.isShowLARFaceTrackingView.toggle()
            }
            viewManager.isShowLConfigurationView.toggle()

            isShow.toggle()
        } label: {
            Image(systemName: "info.circle")
                .resizable()
                .scaledToFit()
        }
        .sheet(isPresented: $isShow) {
            if #available(iOS 16.4, *) {
                Text("Hello World!")
                    .presentationDetents([.large, .medium])
                    .presentationDragIndicator(.visible)
//                    .interactiveDismissDisabled(true)
                    .frame(width: 100, height: 100)
                    .background(.red)
                    .presentationBackground(Color.white.opacity(0.2))
                    .presentationBackgroundInteraction(.disabled)
            } else {
                // Fallback on earlier versions
                Text("Hello World!")
                    .presentationDetents([.large, .medium])
                    .presentationDragIndicator(.visible)
                    .interactiveDismissDisabled(true)
                    .background(.red)
            }
        }
    }
}
