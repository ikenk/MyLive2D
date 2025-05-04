//
//  LChangeModelView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/18.
//

import SwiftUI

struct LChangeModelView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isLeftPressed: Bool = false
    @State private var isRightPressed: Bool = false

    var body: some View {
//            Button {
//                My_LAppLive2DManager.shared().nextScene()
//            } label: {
//                Text("Next Model")
//                    .font(.title2)
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//            .tint(.clear)
//            .foregroundStyle(.primary)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .strokeBorder(.purple, lineWidth: 1)
//            )
//            .padding(.horizontal, 10)
//
//            Button {
//                My_LAppLive2DManager.shared().previousScene()
//            } label: {
//                Text("Previous Model")
//                    .font(.title2)
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//            .tint(.clear)
//            .foregroundStyle(.primary)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .strokeBorder(.purple, lineWidth: 1)
//            )
//            .padding(.horizontal, 10)

        HStack(spacing: 10) {
            Button {
                My_LAppLive2DManager.shared().nextScene()
            } label: {
                Image(systemName: "arrowshape.left")
//                    .font(.title)
                    .font(.system(size: 37))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.primary)
            .padding()
            .background(isLeftPressed ? .gray.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation {
                            isLeftPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            isLeftPressed = false
                        }
                    }
            )

            Button {
                My_LAppLive2DManager.shared().previousScene()
            } label: {
                Image(systemName: "arrowshape.right")
//                    .font(.title)
                    .font(.system(size: 37))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.primary)
            .padding()
            .background(isRightPressed ? .gray.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        withAnimation {
                            isRightPressed = true
                        }
                    }
                    .onEnded { _ in
                        withAnimation {
                            isRightPressed = false
                        }
                    }
            )
        }
    }
}
