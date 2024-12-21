//
//  InfoButton.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/17.
//

import SwiftUI

struct LInfoButton: View {
    @EnvironmentObject var viewManager: LViewManager
    
    var body: some View {
        Button {
            print("[MyLog] LInfoButton Tap")
            if viewManager.isShowLARFaceTrackingView {
                viewManager.isShowLARFaceTrackingView.toggle()
            }
            viewManager.isShowLConfigurationView.toggle()
        } label: {
            Image(systemName: "info.circle")
                .resizable()
                .scaledToFit()
        }
    }
}
