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
//            if viewManager.isShowLARFaceTrackingView {
//                viewManager.isShowLARFaceTrackingView.toggle()
//            }
            viewManager.isShowLConfigurationView.toggle()

            isShow.toggle()
        } label: {
            Image(systemName: "gearshape")
                .resizable()
                .scaledToFit()
        }
        .tint(.clear)
        .foregroundStyle(.primary)
    }
}
