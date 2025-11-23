//
//  ContentView.swift
//  life countdown
//
//  Created by Flora on 2025/10/29.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        ZStack {
            switch appState.currentScreen {
            case .splash:
                // 启动页
                SplashView()
                    .environmentObject(appState)
                    .transition(.opacity)

            case .languageSelection:
                // 语言选择页
                LanguageSelectionView()
                    .environmentObject(appState)
                    .transition(.opacity)

            case .ageInput:
                // 生日输入页
                AgeInputView()
                    .environmentObject(appState)
                    .transition(.opacity)

            case .lifespanInput:
                // 寿命输入页
                LifespanInputView()
                    .environmentObject(appState)
                    .transition(.opacity)

            case .main:
                // 主页面
                // ✨ 修改：确保 ViewModel 总是存在
                MainView(viewModel: appState.mainViewModel ?? MainViewModel(
                    birthDate: appState.birthDate,
                    userLifespan: appState.userLifespan
                ))
                .environmentObject(appState)
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState.currentScreen)
    }
}

#Preview {
    ContentView()
}
