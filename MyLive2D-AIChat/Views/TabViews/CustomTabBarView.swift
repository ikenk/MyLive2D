

import SwiftUI

// 创建一个 PreferenceKey 来收集位置信息
struct IconPositionPreferenceKey: PreferenceKey {
    static var defaultValue: [CGPoint] = []

    static func reduce(value: inout [CGPoint], nextValue: () -> [CGPoint]) {
        value.append(contentsOf: nextValue())
    }
}

// struct IconPositionPreferenceKey: PreferenceKey {
//    static var defaultValue: CGPoint = .zero
//
//    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
//        value = nextValue()
//    }
// }

struct CustomTabBarView: View {
    @Binding var selectedTabItem: TabItem

    @State var offsetXLefAndMiddle: CGFloat = .zero
    @State var offsetXMiddleAndRight: CGFloat = .zero

    var body: some View {
        GeometryReader { geometry in
            HStack {
                ForEach(TabItem.allCases, id: \.rawValue) { tabItem in
                    Button {
                        withAnimation {
                            selectedTabItem = tabItem
                        }
                    } label: {
                        Image(systemName: selectedTabItem == tabItem ? tabItem.selectedIconName : tabItem.defaultIconName)
                            .font(.system(size: 22))
                            .foregroundStyle(.black)
                            .padding()
                            .background(
                                GeometryReader { iconGeometry in
                                    Color.clear
                                        .preference(key: IconPositionPreferenceKey.self, value: [CGPoint(x: iconGeometry.frame(in: .global).midX, y: iconGeometry.frame(in: .global).midY)])
//                                    let _ = print(iconGeometry.frame(in: .global).midX)
//                                    let _ = print(geometry.frame(in: .global).midY)
                                }
                            )
                            .overlay {
                                if tabItem == .Chat {
                                    Circle()
                                        .fill(Color.white.opacity(0.3))
                                        .overlay(
                                            Circle()
                                                .strokeBorder(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.black.opacity(0.15), Color.black.opacity(0.08)]),
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    ),
                                                    lineWidth: 1.5
                                                )
                                        )
                                        .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 1)
                                        .frame(width: 50, height: 50)
                                        .offset(x: selectedTabItem == .Chat ? 0 : selectedTabItem == .Voice ? -offsetXLefAndMiddle : offsetXMiddleAndRight, y: 0)
                                }
                            }
                    }
                    .contentShape(Rectangle()) // 明确定义点击区域形状
                    .frame(maxWidth: 60, maxHeight: 60) // 限制每个按钮的可点击区域
//                    .padding(5)
                    .debugBorder()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .backgroundShadow(cornerRadius: 30, blurRadius: 8, shadowOffset: CGSize(width: 0, height: 4))
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            .onPreferenceChange(IconPositionPreferenceKey.self) { positions in
//                MyLog("position", positions)
//                print("position", positions)
                if positions.count >= 3 {
                    let leftPosition = positions[0]
                    let middlePosition = positions[1]
                    let rightPosition = positions[2]

                    // 计算并保存距离
                    offsetXLefAndMiddle = middlePosition.x - leftPosition.x
                    offsetXMiddleAndRight = rightPosition.x - middlePosition.x
                }
            }
        }
        .frame(width: nil, height: 60)
        .debugBorder()
    }
}

#Preview {
    CustomTabBarView(selectedTabItem: .constant(.Chat))
}
