import SwiftUI

@main
struct LifeCountdownApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            switch appState.currentScreen {
            case .splash:
                SplashView()
                    .environmentObject(appState)

            case .languageSelection:
                LanguageSelectionView()
                    .environmentObject(appState)

            case .ageInput:
                AgeInputView()
                    .environmentObject(appState)

            case .lifespanInput:
                LifespanInputView()
                    .environmentObject(appState)

            case .main:
                // 从 AppState 获取 ViewModel
                if let viewModel = appState.mainViewModel {
                    MainView(viewModel: viewModel)
                        .environmentObject(appState)
                } else {
                    // 如果 ViewModel 不存在（理论上不会发生）
                    Text("Error: ViewModel not initialized")
                        .foregroundColor(.red)
                }
            }
        }
    }
}
