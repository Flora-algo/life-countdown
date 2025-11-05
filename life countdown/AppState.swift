import SwiftUI

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    
    // 用户数据
    @Published var birthDate: Date = Date()
    @Published var userLifespan: Int = 80
    
    // MainViewModel（只创建一次）
    var mainViewModel: MainViewModel? = nil
    
    enum AppScreen {
        case splash
        case ageInput
        case lifespanInput
        case main
    }
    
    func navigateToAgeInput() {
        // 清空 ViewModel，允许重新设置
        mainViewModel = nil
        currentScreen = .ageInput
    }
    
    func navigateToLifespanInput() {
        currentScreen = .lifespanInput
    }
    
    func navigateToMain() {
        // 创建 ViewModel（使用用户输入的数据）
        // 创建 ViewModel（使用用户输入的生日）
                if mainViewModel == nil {
                    mainViewModel = MainViewModel(
                        birthDate: birthDate,  // ← 传生日
                        userLifespan: userLifespan
                    )
        }
        currentScreen = .main
    }
}
