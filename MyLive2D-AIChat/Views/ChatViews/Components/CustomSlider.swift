//
//  CustomSliderView.swift
//  MyLive2D
//
//  Created by HT Zhang  on 2025/05/01.
//

import SwiftUI

/// 当sliderRange为非对称范围时计算左右两边的滑动条长度
func calculateLength(sliderBarLength: Double, sliderRange: ClosedRange<Double>, isLowerBound: Bool = true) -> Double {
    // 避免除以零或非常小的值
    if sliderRange.upperBound - sliderRange.lowerBound < 0.000001 {
        return 0
    }
    
    if isLowerBound {
//        MyLog("Left Range", sliderBarLength / (sliderRange.upperBound - sliderRange.lowerBound) * (sliderRange.lowerBound < 0 ? -sliderRange.lowerBound : sliderRange.lowerBound))
        return sliderBarLength / (sliderRange.upperBound - sliderRange.lowerBound) * (sliderRange.lowerBound < 0 ? -sliderRange.lowerBound : sliderRange.lowerBound)
    } else {
//        MyLog("Right Range", sliderBarLength / (sliderRange.upperBound - sliderRange.lowerBound) * (sliderRange.upperBound < 0 ? -sliderRange.upperBound : sliderRange.upperBound))
        return sliderBarLength / (sliderRange.upperBound - sliderRange.lowerBound) * (sliderRange.upperBound < 0 ? -sliderRange.upperBound : sliderRange.upperBound)
    }
}

struct CustomSlider: View {
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var sliderVariant: Float

    @State var sliderRange: ClosedRange<Double>
    @State var sliderVariantName: String
    var isInteger: Bool = false

    @State private var sliderBarLength: Double = 0
    @State private var sliderPosition: CGFloat = 0 // 滑块实际位置
    @State private var sliderFinalOffset: CGFloat = 0

    var sliderSize: CGSize = .init(width: 18, height: 18)
    
    var fontColor: Color {
        colorScheme == .light ? .black : .white
    }
    
    var sliderColor: Color {
        colorScheme == .light ? .black.opacity(0.3) : .white.opacity(1)
    }
    
    var sliderBarColor: Color {
        colorScheme == .light ? .blue : .teal
    }
    
    var sliderBarBackgroundColor: Color {
        colorScheme == .light ? Color.gray.opacity(0.2) : Color.white
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("\(sliderVariantName)")
                    .font(.subheadline)
                    .foregroundColor(fontColor)
                Spacer()
                Text(isInteger ? String(format: "%.0f", sliderVariant) : String(format: "%.2f", sliderVariant))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(fontColor)
            }

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(sliderBarBackgroundColor)
                    .frame(height: 8)
                    .background(
                        GeometryReader(content: { proxy in
                            Color.clear
                                .onAppear {
                                    sliderBarLength = proxy.size.width
                                }
                        })
                    )
                
                if sliderRange.lowerBound * sliderRange.upperBound < 0 {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(sliderBarColor)
                            // FIXME: sliderBarLength / (sliderRange.upperBound - sliderRange.lowerBound) * (-sliderRange.lowerBound)  -> sliderBarLength / 2 功能完好，暂时不管
                            .frame(width: calculateLength(sliderBarLength: sliderBarLength, sliderRange: sliderRange), height: 8)
                        
                        RoundedRectangle(cornerRadius: 10)
                            //                            .fill(Color(white: 0.9, opacity: 1.0))
                            .fill(Color.white) // 先铺一层不透明的底
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(sliderBarBackgroundColor) // 再叠加灰色透明
                            )
                            // FIXME: sliderBarLength / (sliderRange.upperBound - sliderRange.lowerBound) * (-sliderRange.lowerBound) -> sliderBarLength / 2 功能完好，暂时不管
                            .frame(width: calculateLength(sliderBarLength: sliderBarLength, sliderRange: sliderRange) + CGFloat(sliderVariant / (Float(sliderRange.upperBound - sliderRange.lowerBound) / 2)) * (sliderBarLength / 2), height: 8)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(sliderBarColor)
                            .frame(width: CGFloat(max(0, sliderVariant) / Float(sliderRange.upperBound) * Float(calculateLength(sliderBarLength: sliderBarLength, sliderRange: sliderRange, isLowerBound: false))), height: 8)
                            .offset(x: calculateLength(sliderBarLength: sliderBarLength, sliderRange: sliderRange, isLowerBound: true))
                    }
                    .overlay(alignment: .leading, content: {
                        ZStack {
                            GeometryReader { proxy in
                                Circle()
                                    .fill(Color.white)
                                    .overlay(content: {
                                        Circle()
                                            .foregroundStyle(sliderColor)
                                    })
                                    .frame(width: sliderSize.width, height: sliderSize.height)
                                    .position(x: calculateLength(sliderBarLength: sliderBarLength, sliderRange: sliderRange) + sliderPosition, y: proxy.size.height / 2)
                                
                                Circle()
                                    .foregroundStyle(.black.opacity(0.01))
                                    .frame(width: sliderSize.width, height: sliderSize.height)
                                    .position(x: calculateLength(sliderBarLength: sliderBarLength, sliderRange: sliderRange) + sliderFinalOffset, y: proxy.size.height / 2)
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { value in
                                                // 计算新的滑块位置
                                                let dragPosition = value.location.x
                                                let startPosition = calculateLength(sliderBarLength: sliderBarLength, sliderRange: sliderRange)
                                                
                                                // 计算相对于起始点的位置
                                                let relativePosition = max(-calculateLength(sliderBarLength: sliderBarLength, sliderRange: sliderRange, isLowerBound: true), min(dragPosition - startPosition, calculateLength(sliderBarLength: sliderBarLength, sliderRange: sliderRange, isLowerBound: false)))
                                                
                                                // 更新位置
                                                sliderPosition = relativePosition
                                                
                                                // 更新值（映射到值范围）
                                                let rangeSize = Float(sliderRange.upperBound - sliderRange.lowerBound)
                                                let percentage = Float(relativePosition / (sliderBarLength / 2))
                                                
                                                // 限制在范围内
                                                sliderVariant = max(
                                                    Float(sliderRange.lowerBound),
                                                    min(percentage * rangeSize / 2, Float(sliderRange.upperBound))
                                                )
                                            }
                                            .onEnded { _ in
                                                sliderFinalOffset = sliderPosition
                                            }
                                    )
                            }
                        }
                        .onChange(of: sliderBarLength) { newValue in
                            if(sliderVariant < 0) {
                                let startPosition = (sliderVariant / Float(sliderRange.lowerBound)) * Float(calculateLength(sliderBarLength: newValue, sliderRange: sliderRange))
                                sliderPosition = -CGFloat(startPosition)
                                sliderFinalOffset = -CGFloat(startPosition)
                            } else {
                                let startPosition = (sliderVariant / Float(sliderRange.upperBound)) * Float(calculateLength(sliderBarLength: newValue, sliderRange: sliderRange, isLowerBound: false))
                                sliderPosition = CGFloat(startPosition)
                                sliderFinalOffset = CGFloat(startPosition)
                            }
                            
                        }
                    })
                    .onAppear {
                        sliderPosition = 0
                        sliderFinalOffset = 0
                    }
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(sliderBarColor)
                        .frame(width: CGFloat(abs(sliderVariant - Float(sliderRange.lowerBound)) / Float(sliderRange.upperBound - sliderRange.lowerBound)) * sliderBarLength, height: 8)
                        .overlay(alignment: .leading, content: {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .overlay(content: {
                                        Circle()
                                            .foregroundStyle(sliderColor)
                                    })
                                    .frame(width: sliderSize.width, height: sliderSize.height)
                                    .offset(x: sliderPosition)
                                
                                Circle()
                                    .foregroundStyle(.black.opacity(0.01))
                                    .frame(width: sliderSize.width, height: sliderSize.height)
                                    .offset(x: sliderFinalOffset)
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { value in
                                                //                                                print(value.location.x)
                                                
                                                // 计算新的滑块位置
                                                let dragPosition = value.location.x
                                                let startPosition = 0.0
                                                
                                                // 计算相对于起始点的位置
                                                let relativePosition = max(0, min(dragPosition - startPosition, sliderBarLength))
                                                
                                                // 更新位置
                                                sliderPosition = relativePosition - sliderSize.width / 2
                                                
//                                                print("relativePosition:\(relativePosition)")
                                                
                                                // 更新值（映射到值范围）
                                                let rangeSize = Float(sliderRange.upperBound - sliderRange.lowerBound)
                                                let percentage = Float(relativePosition / sliderBarLength)
                                                
                                                sliderVariant = percentage * rangeSize + Float(sliderRange.lowerBound)
                                                
//                                                print("sliderVariant:\(sliderVariant)")
                                                
                                                //                                            sliderVariant = max(min(sliderVariant + Float(sliderOffset / sliderBarLength) * Float(sliderRange.upperBound - sliderRange.lowerBound), Float(sliderRange.upperBound - sliderRange.lowerBound)), 0)
                                            }
                                            .onEnded { _ in
                                                sliderFinalOffset = sliderPosition
                                            }
                                    )
                            }
                            .onChange(of: sliderBarLength) { newValue in
                                let startPosition = ((sliderVariant - Float(sliderRange.lowerBound)) / Float(sliderRange.upperBound - sliderRange.lowerBound)) * Float(newValue)
                                sliderPosition = -sliderSize.width / 2 + CGFloat(startPosition)
                                sliderFinalOffset = -sliderSize.width / 2 + CGFloat(startPosition)
                            }
                        })
                        .onAppear {
//                            if sliderRange.lowerBound * sliderRange.upperBound > 0 {
//                                sliderVariant = Float(sliderRange.lowerBound)
//                            }
                            sliderPosition = -sliderSize.width / 2
                            sliderFinalOffset = -sliderSize.width / 2
                        }
                }
            }
        }
        .padding(.vertical)
    }
}
