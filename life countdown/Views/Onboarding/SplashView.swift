import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var languageManager = LanguageManager.shared

    // 检测设备类型
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // ✨ 改进：根据屏幕宽度动态计算缩放倍数
    private var scaleFactor: CGFloat {
        if isIPad {
            // 获取屏幕宽度
            let screenWidth = UIScreen.main.bounds.width
            
            // 根据不同 iPad 尺寸调整
            // iPad 13-inch: ~1024pts
            // iPad 17-inch: ~1366pts
            if screenWidth > 1200 {
                return 2.2  // iPad 17-inch 或更大
            } else {
                return 1.8  // iPad 13-inch
            }
        } else {
            return 1.0  // iPhone
        }
    }
    
    var body: some View {
        GeometryReader { geometry in  // ✨ 使用 GeometryReader
            ZStack(alignment: .topLeading) {

                // 背景色
                Color(red: 0.09, green: 0.13, blue: 0.20)
                    .ignoresSafeArea()
                    .onTapGesture {
                        // 点击任意位置跳转到语言选择
                        appState.navigateToLanguageSelectionFromSplash()
                    }
                
                // ✨ 改用相对定位而不是绝对定位
                VStack(spacing: 0) {
                    // 顶部空白
                    Spacer()
                        .frame(height: geometry.size.height * 0.2)  // 屏幕高度的 15%
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 26 * scaleFactor) {
                            // Logo
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 89 * scaleFactor, height: 60 * scaleFactor)
                            
                            // App 名称
                            Text("splash_title".localized())
                                .font(.system(size: 32 * scaleFactor, weight: .thin))
                                .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                        }
                        .padding(.leading, 59 * scaleFactor)
                        
                        Spacer()
                    }
                    
                    Spacer()

                    // 前进按钮
                    HStack {
                        NavigationButton {
                            appState.navigateToLanguageSelectionFromSplash()
                        }
                        .scaleEffect(scaleFactor)
                        .padding(.leading, 59 * scaleFactor)

                        Spacer()
                    }
                    .padding(.bottom, geometry.size.height * 0.25)  // 屏幕高度的 30%
                }
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState())
}
