//
//  LSliderView.swift
//  MyLive2D-SwiftUI
//
//  Created by HT Zhang  on 2024/12/18.
//

import SwiftUI

struct LSliderView: View {
    @State private var modelParameter: LModelConfigurationParameter = .init()

    var body: some View {
        Section {
            Group {
                VStack(spacing: 5) {
                    Text("X Translation")
                        .foregroundStyle(.primary)

                    Slider(value: $modelParameter.xTranslation, in: -Float(UIScreen.main.bounds.width) / Float(UIScreen.main.bounds.height) ... Float(UIScreen.main.bounds.width) / Float(UIScreen.main.bounds.height)) {
                        Text("X Translation")
                    } minimumValueLabel: {
//                        Text("\((-Float(UIScreen.main.bounds.width) / 2).formatted(.number.precision(.fractionLength(0))))")
//                            .font(.callout)
                        Text("Left")
                            .font(.callout)
                    } maximumValueLabel: {
//                        Text("\((Float(UIScreen.main.bounds.width) / 2).formatted(.number.precision(.fractionLength(0))))")
//                            .font(.callout)
                        Text("Right")
                            .font(.callout)
                    }
                    .onChange(of: modelParameter.xTranslation) { newValue in

                        MyLog("modelParameter.xTranslation", newValue)
                        My_LAppLive2DManager.shared().setModelPositionOnX(newValue)
                    }
                }

                VStack(spacing: 5) {
                    Text("Y Translation")
                        .foregroundStyle(.primary)

                    Slider(value: $modelParameter.yTranslation, in: -1 ... 1) {
                        Text("Y Translation")
                    } minimumValueLabel: {
//                        Text("\((-Float(UIScreen.main.bounds.height) / 2).formatted(.number.precision(.fractionLength(0))))")
//                            .font(.callout)
                        Text("Down")
                            .font(.callout)
                    } maximumValueLabel: {
//                        Text("\((Float(UIScreen.main.bounds.height) / 2).formatted(.number.precision(.fractionLength(0))))")
//                            .font(.callout)
                        Text("Up")
                            .font(.callout)
                    }
                    .onChange(of: modelParameter.yTranslation) { newValue in

                        MyLog("modelParameter.yTranslation", newValue)
                        My_LAppLive2DManager.shared().setModelPositionOnY(newValue)
                    }
                }

                VStack(spacing: 5) {
                    Text("Scale")
                        .foregroundStyle(.primary)

                    Slider(value: $modelParameter.scale, in: 1 ... 3) {
                        Text("Scale")
                    } minimumValueLabel: {
                        Text("1")
                            .font(.callout)
                    } maximumValueLabel: {
                        Text("3")
                            .font(.callout)
                    }
                    .onChange(of: modelParameter.scale) { newValue in

                        MyLog("modelParameter.scale", newValue)
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
            .padding(.bottom, 10)
        } header: {
            Text("Change Model Position And Size")
        }
    }
}
