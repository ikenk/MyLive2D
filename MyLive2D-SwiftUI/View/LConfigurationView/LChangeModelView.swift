//
//  LChangeModelView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/18.
//

import SwiftUI

struct LChangeModelView:View {
    var body:some View {
        Section {
            Button {
                My_LAppLive2DManager.shared().nextScene()
            } label: {
                Text("Next Model")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.clear)
            .foregroundStyle(.primary)
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
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.clear)
            .foregroundStyle(.primary)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(.purple, lineWidth: 1)
            )
            .padding(.horizontal, 10)
        } header: {
            Text("Change Model")
        }
    }
}
