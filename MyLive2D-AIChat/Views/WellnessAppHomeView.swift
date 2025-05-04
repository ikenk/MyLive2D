////
////  WellnessAppHomeView.swift
////  MyLive2D
////
////  Created by HT Zhang  on 2025/04/27.
////
//
// import SwiftUI
//
// struct WellnessAppHomeView: View {
//    var body: some View {
//        ZStack {
//            // 背景渐变
//            LinearGradient(
//                gradient: Gradient(colors: [Color(hex: "413159"), Color(hex: "2d2442")]),
//                startPoint: .top,
//                endPoint: .bottom
//            )
//            .ignoresSafeArea()
//
//            // 星星背景效果
//            StarryBackground()
//
//            // 主内容
//            VStack(alignment: .leading, spacing: 20) {
//                // 顶部导航栏
//                HStack {
//                    Button(action: {}) {
//                        Image(systemName: "square.grid.2x2")
//                            .foregroundColor(.white.opacity(0.7))
//                            .font(.system(size: 20))
//                            .frame(width: 40, height: 40)
//                            .background(Color.white.opacity(0.15))
//                            .cornerRadius(12)
//                    }
//
//                    Spacer()
//
//                    HStack(spacing: 8) {
//                        Image(systemName: "crown.fill")
//                            .foregroundColor(.yellow)
//                        Text("685")
//                            .foregroundColor(.white)
//                            .fontWeight(.bold)
//                        Text("pts")
//                            .foregroundColor(.white.opacity(0.7))
//                    }
//                    .padding(.horizontal, 14)
//                    .padding(.vertical, 8)
//                    .background(Color.white.opacity(0.15))
//                    .cornerRadius(20)
//
//                    Spacer()
//
//                    Button(action: {}) {
//                        Image(systemName: "bell.fill")
//                            .foregroundColor(.white.opacity(0.7))
//                            .font(.system(size: 20))
//                            .frame(width: 40, height: 40)
//                            .background(Color.white.opacity(0.15))
//                            .cornerRadius(12)
//                    }
//
//                    Button(action: {}) {
//                        Image("profile")
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 32, height: 32)
//                            .clipShape(Circle())
//                    }
//                }
//
//                // 欢迎和总结部分
//                VStack(alignment: .leading, spacing: 4) {
//                    HStack {
//                        Text("Hello, Lisa")
//                            .font(.title)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//
//                        Image(systemName: "arrow.up.right")
//                            .foregroundColor(.white.opacity(0.7))
//                    }
//
//                    Text("Today's Summary")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//
//                    Text("For You")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                }
//
//                // 活动统计
//                HStack {
//                    Text("01")
//                        .font(.system(size: 35, weight: .bold))
//                        .foregroundColor(.white)
//
//                    Text("|")
//                        .font(.system(size: 35))
//                        .foregroundColor(.white.opacity(0.3))
//
//                    Text("03")
//                        .font(.system(size: 35, weight: .bold))
//                        .foregroundColor(.white)
//
//                    Spacer()
//
//                    VStack(alignment: .trailing, spacing: 2) {
//                        Text("Tot activities")
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.7))
//
//                        Text("Today")
//                            .font(.subheadline)
//                            .foregroundColor(.white.opacity(0.7))
//                    }
//
//                    Button(action: {}) {
//                        Image(systemName: "calendar")
//                            .foregroundColor(.primary)
//                            .font(.system(size: 20))
//                            .padding(10)
//                            .background(Color.white)
//                            .clipShape(Circle())
//                    }
//                }
//                .padding(.vertical, 10)
//                .padding(.horizontal, 20)
//                .background(Color.white.opacity(0.1))
//                .cornerRadius(20)
//
//                // 特色冥想部分
//                VStack(alignment: .leading, spacing: 10) {
//                    Text("Featured Meditations")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//
//                    // 冥想卡片
//                    HStack(spacing: 15) {
//                        // 第一个冥想卡片
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Text("9 min")
//                                    .font(.caption)
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 8)
//                                    .padding(.vertical, 4)
//                                    .background(Color.white.opacity(0.2))
//                                    .cornerRadius(10)
//
//                                Spacer()
//
//                                Image("water-drop")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .opacity(0.7)
//                            }
//
//                            Spacer()
//
//                            Text("Deep Sleep")
//                                .font(.title3)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//
//                            Text("Relaxing sounds for better rest & dreams")
//                                .font(.caption)
//                                .foregroundColor(.white.opacity(0.8))
//                                .lineLimit(2)
//                        }
//                        .padding()
//                        .frame(width: 170, height: 160)
//                        .background(LinearGradient(
//                            gradient: Gradient(colors: [Color(hex: "FF5B94"), Color(hex: "FF8FB2")]),
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        ))
//                        .cornerRadius(20)
//
//                        // 第二个冥想卡片
//                        VStack(alignment: .leading, spacing: 8) {
//                            HStack {
//                                Text("5 min")
//                                    .font(.caption)
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 8)
//                                    .padding(.vertical, 4)
//                                    .background(Color.white.opacity(0.2))
//                                    .cornerRadius(10)
//
//                                Spacer()
//
//                                Image("circles")
//                                    .resizable()
//                                    .frame(width: 30, height: 30)
//                                    .opacity(0.7)
//                            }
//
//                            Spacer()
//
//                            Text("Focus Mode")
//                                .font(.title3)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//
//                            Text("Enhance productivity with ambient sounds")
//                                .font(.caption)
//                                .foregroundColor(.white.opacity(0.8))
//                                .lineLimit(2)
//                        }
//                        .padding()
//                        .frame(width: 170, height: 160)
//                        .background(LinearGradient(
//                            gradient: Gradient(colors: [Color(hex: "4A7BF7"), Color(hex: "7095FF")]),
//                            startPoint: .topLeading,
//                            endPoint: .bottomTrailing
//                        ))
//                        .cornerRadius(20)
//                    }
//                }
//
//                // 聊天输入框
//                HStack {
//                    Image(systemName: "mic.fill")
//                        .foregroundColor(.gray)
//                        .padding(.leading)
//
//                    Text("Chat with Mindbot...")
//                        .foregroundColor(.gray)
//
//                    Spacer()
//
//                    Button(action: {}) {
//                        Image(systemName: "arrow.up.circle.fill")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .padding(8)
//                            .background(Color(hex: "413159"))
//                            .clipShape(Circle())
//                    }
//                    .padding(.trailing, 5)
//                }
//                .padding(.vertical, 12)
//                .background(Color.white)
//                .cornerRadius(30)
//
//                Spacer()
//
//                // 底部导航栏
//                HStack(spacing: 0) {
//                    Spacer()
//
//                    Button(action: {}) {
//                        VStack {
//                            Image(systemName: "house.fill")
//                                .font(.system(size: 20))
//                                .foregroundColor(.white)
//                        }
//                        .frame(width: 60)
//                    }
//
//                    Spacer()
//
//                    Button(action: {}) {
//                        VStack {
//                            Image(systemName: "list.bullet")
//                                .font(.system(size: 20))
//                                .foregroundColor(.white.opacity(0.5))
//                        }
//                        .frame(width: 60)
//                    }
//
//                    Spacer()
//
//                    Button(action: {}) {
//                        VStack {
//                            Image(systemName: "gear")
//                                .font(.system(size: 20))
//                                .foregroundColor(.white.opacity(0.5))
//                        }
//                        .frame(width: 60)
//                    }
//
//                    Spacer()
//                }
//                .padding(.vertical, 10)
//                .background(Color.white.opacity(0.1))
//                .cornerRadius(30)
//            }
//            .padding(20)
//        }
//    }
// }
//
//// 星星背景视图
// struct StarryBackground: View {
//    let stars = (0..<50).map { _ in
//        StarInfo(
//            position: CGPoint(
//                x: CGFloat.random(in: 0...1),
//                y: CGFloat.random(in: 0...1)
//            ),
//            size: CGFloat.random(in: 1...3),
//            opacity: Double.random(in: 0.1...0.5)
//        )
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            ForEach(stars.indices, id: \.self) { index in
//                let star = stars[index]
//                Circle()
//                    .fill(Color.white)
//                    .frame(width: star.size, height: star.size)
//                    .position(
//                        x: star.position.x * geometry.size.width,
//                        y: star.position.y * geometry.size.height
//                    )
//                    .opacity(star.opacity)
//            }
//        }
//    }
// }
//
// struct StarInfo {
//    let position: CGPoint
//    let size: CGFloat
//    let opacity: Double
// }
//
//// 颜色扩展，支持十六进制颜色
// extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3: // RGB (12-bit)
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6: // RGB (24-bit)
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8: // ARGB (32-bit)
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 0)
//        }
//        self.init(
//            .sRGB,
//            red: Double(r) / 255,
//            green: Double(g) / 255,
//            blue: Double(b) / 255,
//            opacity: Double(a) / 255
//        )
//    }
// }
//
// struct WellnessAppHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WellnessAppHomeView()
//    }
// }

import PhotosUI
import SwiftUI

struct TestView: View {
    @State private var isPlayBtnActive: Bool = true
    @State private var isARBtnActive: Bool = true

    @State private var isLeftPressed: Bool = false
    @State private var isRightPressed: Bool = false

    @State private var isPicBtnPressed: Bool = false
    @State private var isLoading:Bool = true
    
    @State private var sliderVariant:Float = 2
    var body: some View {
        HStack(spacing: 10) {
            Button {
                print("456")
            } label: {
                Image(systemName: "arrowshape.left")
//                    .font(.title)
                    .font(.system(size: 37))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Color.init(uiColor: .systemBackground))
            .padding()
            .background(isLeftPressed ? .gray.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        print("123")
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

            Button {} label: {
                Image(systemName: "arrowshape.right")
//                    .font(.title)
                    .font(.system(size: 37))
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
            .foregroundStyle(Color.init(uiColor: .systemBackground))
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

        HStack(spacing: 10) {
            Button {
                withAnimation(.spring()) {
                    isARBtnActive.toggle()
                }
            } label: {
                Image(systemName: "person.and.background.dotted")
//                    .font(.title)
                    .font(.system(size: 37))
                    .frame(width: 44, height: 44)
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
            }
//            .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60)
            .buttonStyle(.plain)
            .foregroundStyle(isARBtnActive ? .green : .black)
            .padding()
            .background(isARBtnActive ? .gray.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 3))

            Button {
                withAnimation(.spring()) {
                    isPlayBtnActive.toggle()
                }
            } label: {
                Image(systemName: "play")
//                    .font(.title)
                    .font(.system(size: 37))
                    .frame(width: 44, height: 44)
            }
//            .frame(minWidth: 30, maxWidth: 60, minHeight: 30, maxHeight: 60)
            .buttonStyle(.plain)
            .foregroundStyle(isPlayBtnActive ? .blue : .black)
            .padding()
            .background(isPlayBtnActive ? .gray.opacity(0.1) : .clear)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 3))
        }

        ZStack {
            PhotosPicker(selection: .constant(nil), matching: PHPickerFilter.bursts, preferredItemEncoding: .compatible) {
                Image(systemName: "photo.stack")
                    .font(.system(size: 33))
                    .frame(width: 44, height: 44)
                    .foregroundStyle(Color.init(uiColor: .systemBackground).opacity(0.7))
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .backgroundShadow(cornerRadius: 20, blurRadius: 3, shadowOffset: CGSize(width: 0, height: 1))
            }
            .disabled(isLoading)
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(DarkModeProgressViewStyle())
            }
        }
        
        VStack(spacing: 10) {
            CustomSlider(sliderVariant: $sliderVariant, sliderRange:-UIScreen.main.bounds.size.width ... UIScreen.main.bounds.size.width, sliderVariantName: "X Tanslation")
            
            CustomSlider(sliderVariant: $sliderVariant, sliderRange:-UIScreen.main.bounds.size.height ... UIScreen.main.bounds.size.height, sliderVariantName: "Y Tanslation")
            
            CustomSlider(sliderVariant: $sliderVariant, sliderRange:0 ... 3, sliderVariantName: "Scale")
            
            CustomSlider(sliderVariant: $sliderVariant, sliderRange:-(UIScreen.main.bounds.width) / (UIScreen.main.bounds.height) ... (UIScreen.main.bounds.width) / (UIScreen.main.bounds.height), sliderVariantName: "X Tanslation")
            
            CustomSlider(sliderVariant: $sliderVariant, sliderRange:-1 ... 3, sliderVariantName: "C")
        }
        .padding(.horizontal)
        
        Button {
        } label: {
            Image(systemName: "info.circle")
                .resizable()
                .scaledToFit()
        }
        .tint(.clear)
        .foregroundStyle(.primary)
    }
}

#Preview {
    TestView()
}
