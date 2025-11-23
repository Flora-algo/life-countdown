import SwiftUI

struct LifespanInputView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var languageManager = LanguageManager.shared
    @State private var lifespan: String = ""
    
    // 设备检测
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // ✨ 改进：动态缩放倍数（和 AgeInputView 一致）
    private var scaleFactor: CGFloat {
        if isIPad {
            let screenWidth = UIScreen.main.bounds.width
            if screenWidth > 1200 {
                return 2.2  // iPad 17-inch
            } else {
                return 1.8  // iPad 13-inch
            }
        } else {
            return 1.0  // iPhone
        }
    }
    
    var body: some View {
        GeometryReader { geometry in  // ✨ 使用 GeometryReader
            ZStack {
                // 背景色
                Color(red: 0.09, green: 0.13, blue: 0.20)
                    .ignoresSafeArea()
                
                // 主内容
                VStack(spacing: 0) {
                    // ✨ 顶部空白（屏幕高度的 18% - 和 AgeInputView 一致）
                    Spacer()
                        .frame(height: geometry.size.height * 0.25)
                    
                    // 标题
                    Text("lifespan_input_title".localized())
                        .font(.system(size: 22 * scaleFactor, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                    
                    // ✨ 标题到输入框的间距（屏幕高度的 7% - 和 AgeInputView 一致）
                    Spacer()
                        .frame(height: geometry.size.height * 0.07)
                    
                    // 输入框（占据中间位置，和 Picker 高度类似）
                    NumberInputField(
                        text: $lifespan,
                        placeholder: "lifespan_placeholder".localized(),
                        unit: "lifespan_unit".localized()
                    )
                    .scaleEffect(scaleFactor)
                    .frame(height: 150 * scaleFactor)  // ✨ 给一个固定高度，让视觉上和 Picker 对齐
                    
                    // ✨ 输入框到按钮的间距（屏幕高度的 7% - 和 AgeInputView 一致）
                    Spacer()
                        .frame(height: geometry.size.height * 0.04)
                    
                    // 前进按钮
                    NavigationButton {
                        if let lifespanValue = Int(lifespan) {
                            appState.userLifespan = lifespanValue
                        }
                        appState.navigateToMain()
                    }
                    
                    // 弹性空白（自动填充剩余空间）
                    Spacer()
                    
                    // Logo（距底部固定距离）
                    LogoView(scale: 0.74)
                        .padding(.bottom, 28 * scaleFactor)
                }
                
                // 返回按钮（浮动）
                VStack {
                    HStack {
                        Button(action: {
                            appState.navigateBackToAgeInput()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20 * scaleFactor))
                                .foregroundColor(Color(red: 50/255, green: 65/255, blue: 80/255))
                                .padding(12 * scaleFactor)
                        }
                        
                        Spacer()
                    }
                    .padding(.leading, 8 * scaleFactor)
                    .padding(.top, 10 * scaleFactor)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            if appState.userLifespan > 0 && appState.userLifespan != 80 {
                lifespan = "\(appState.userLifespan)"
            }
        }
    }
}

#Preview {
    let appState = AppState()
    appState.userLifespan = 80
    
    return LifespanInputView()
        .environmentObject(appState)
}
