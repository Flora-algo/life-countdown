import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var languageManager = LanguageManager.shared
    @State private var selectedLanguage: AppLanguage?
    @State private var showButton: Bool = false

    // 设备检测
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    // 动态缩放倍数
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
        GeometryReader { geometry in
            ZStack {
                // 背景色
                Color(red: 0.09, green: 0.13, blue: 0.20)
                    .ignoresSafeArea()

                // 主内容
                VStack(spacing: 0) {
                    // 顶部空白（和 LifespanInputView 一致）
                    Spacer()
                        .frame(height: geometry.size.height * 0.25)

                    // 三个语言选项
                    VStack(spacing: 65 * scaleFactor) {
                        // English
                        LanguageOptionButton(
                            language: .english,
                            isSelected: selectedLanguage == .english,
                            scaleFactor: scaleFactor
                        ) {
                            selectedLanguage = .english
                            if !appState.isEditingFromMain && !showButton {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    showButton = true
                                }
                            }
                        }

                        // 繁體中文
                        LanguageOptionButton(
                            language: .traditionalChinese,
                            isSelected: selectedLanguage == .traditionalChinese,
                            scaleFactor: scaleFactor
                        ) {
                            selectedLanguage = .traditionalChinese
                            if !appState.isEditingFromMain && !showButton {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    showButton = true
                                }
                            }
                        }

                        // 日本語
                        LanguageOptionButton(
                            language: .japanese,
                            isSelected: selectedLanguage == .japanese,
                            scaleFactor: scaleFactor
                        ) {
                            selectedLanguage = .japanese
                            if !appState.isEditingFromMain && !showButton {
                                withAnimation(.easeIn(duration: 0.5)) {
                                    showButton = true
                                }
                            }
                        }
                    }

                    // 语言选项到前进按钮的间距
                    Spacer()
                        .frame(height: 65 * scaleFactor)

                    // 前进按钮
                    if showButton {
                        NavigationButton {
                            // 保存选择的语言
                            if let language = selectedLanguage {
                                languageManager.setLanguage(language)
                            }
                            // 跳转到出生日期输入
                            appState.navigateToAgeInputFromLanguageSelection()
                        }
                        .opacity(showButton ? 1 : 0)
                    }

                    // 弹性空白
                    Spacer()

                    // 横线（在 Logo 上方 22）
                    Rectangle()
                        .fill(Color(red: 0x2F/255.0, green: 0x4E/255.0, blue: 0x55/255.0))
                        .frame(width: 335 * scaleFactor, height: 0.5)
                        .padding(.bottom, 22 * scaleFactor)

                    // Logo（距底部固定距离）
                    LogoView(scale: 0.74)
                        .padding(.bottom, 28 * scaleFactor)
                }

                // 返回按钮（仅在从 MainView 来时显示）
                if appState.isEditingFromMain {
                    VStack {
                        HStack {
                            Button(action: {
                                appState.cancelEditingAndReturnToMain()
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
        }
        .onAppear {
            // 从 MainView 进入时，显示当前语言和按钮
            if appState.isEditingFromMain {
                selectedLanguage = languageManager.currentLanguage
                showButton = true
            }
            // 从 SplashView 进入时，不选中任何语言，不显示按钮
        }
    }
}

// 语言选项按钮组件
struct LanguageOptionButton: View {
    let language: AppLanguage
    let isSelected: Bool
    let scaleFactor: CGFloat
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(language.displayName)
                .font(.system(size: 20 * scaleFactor, weight: .regular))
                .foregroundColor(isSelected ? .white : Color(red: 0x7A/255.0, green: 0xD3/255.0, blue: 0xCA/255.0))
        }
    }
}

#Preview {
    LanguageSelectionView()
        .environmentObject(AppState())
}
