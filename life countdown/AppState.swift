import SwiftUI

class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .splash
    
    // 用户数据
    @Published var birthDate: Date = Date()
    @Published var userLifespan: Int = 80
    
    // MainViewModel（只创建一次）
    var mainViewModel: MainViewModel? = nil
    
    // 标记是否是从主页面进入修改模式
    @Published var isEditingFromMain: Bool = false
    
    // UserDefaults 的 key
    private let birthDateKey = "userBirthDate"
    private let lifespanKey = "userLifespan"
    private let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    
    init() {
        // ✨ 临时：用于测试首次打开（测试时取消注释）
        // resetOnboarding()
        
        // 从 UserDefaults 读取保存的数据
        loadUserData()
        
        // 检查是否已经完成过设置
        if hasCompletedOnboarding() {
            // 已完成设置，直接进入主页面
            currentScreen = .main
            // 创建 ViewModel
            mainViewModel = MainViewModel(
                birthDate: birthDate,
                userLifespan: userLifespan
            )
        } else {
            // 未完成设置，显示启动页
            currentScreen = .splash
        }
    }
    
    enum AppScreen {
        case splash
        case languageSelection
        case ageInput
        case lifespanInput
        case main
    }
    
    // 保存数据到 UserDefaults
    private func saveUserData() {
        UserDefaults.standard.set(birthDate, forKey: birthDateKey)
        UserDefaults.standard.set(userLifespan, forKey: lifespanKey)
        UserDefaults.standard.set(true, forKey: hasCompletedOnboardingKey)
    }
    
    // 从 UserDefaults 读取数据
    private func loadUserData() {
        if let savedDate = UserDefaults.standard.object(forKey: birthDateKey) as? Date {
            birthDate = savedDate
        }
        
        let savedLifespan = UserDefaults.standard.integer(forKey: lifespanKey)
        if savedLifespan > 0 {
            userLifespan = savedLifespan
        }
    }
    
    // 检查是否已完成设置
    func hasCompletedOnboarding() -> Bool {
        return UserDefaults.standard.bool(forKey: hasCompletedOnboardingKey)
    }
    
    // 重置数据（用于测试或重新设置）
    func resetOnboarding() {
        UserDefaults.standard.removeObject(forKey: birthDateKey)
        UserDefaults.standard.removeObject(forKey: lifespanKey)
        UserDefaults.standard.removeObject(forKey: hasCompletedOnboardingKey)
        mainViewModel = nil
        isEditingFromMain = false
        currentScreen = .splash
    }
    
    // 从启动页跳转到语言选择（首次设置）
    func navigateToLanguageSelectionFromSplash() {
        isEditingFromMain = false
        currentScreen = .languageSelection
    }

    // 从主页面设置跳转到语言选择（编辑模式）
    func navigateToLanguageSelectionFromMain() {
        // 清空 ViewModel，允许重新设置
        mainViewModel = nil
        // 标记为编辑模式
        isEditingFromMain = true
        currentScreen = .languageSelection
    }

    // 从语言选择页面跳转到出生日期输入
    func navigateToAgeInputFromLanguageSelection() {
        currentScreen = .ageInput
    }

    // 从主页面进入修改模式（保留旧方法，用于直接跳转到出生日期）
    func navigateToAgeInput() {
        // 清空 ViewModel，允许重新设置
        mainViewModel = nil
        // 标记为编辑模式
        isEditingFromMain = true
        currentScreen = .ageInput
    }

    // 从启动页进入（首次设置，保留旧方法）
    func navigateToAgeInputFromSplash() {
        // 标记为首次设置
        isEditingFromMain = false
        currentScreen = .ageInput
    }

    // 从语言选择页面返回到启动页
    func navigateBackToSplash() {
        currentScreen = .splash
    }
    
    func navigateToLifespanInput() {
        // 保存生日数据
        saveUserData()
        currentScreen = .lifespanInput
    }
    
    func navigateToMain() {
        // 保存所有数据
        saveUserData()
        
        // 创建 ViewModel（使用用户输入的数据）
        if mainViewModel == nil {
            mainViewModel = MainViewModel(
                birthDate: birthDate,
                userLifespan: userLifespan
            )
        }
        // 重置编辑模式标记
        isEditingFromMain = false
        currentScreen = .main
    }
    
    // 从寿命页返回到生日页
    func navigateBackToAgeInput() {
        currentScreen = .ageInput
    }
    
    // ✨ 修改：取消编辑，返回主页面
    func cancelEditingAndReturnToMain() {
        // 重新加载原来的数据（取消修改）
        loadUserData()
        
        // ✨ 确保 mainViewModel 存在
        if mainViewModel == nil {
            mainViewModel = MainViewModel(
                birthDate: birthDate,
                userLifespan: userLifespan
            )
        }
        
        // 重置编辑模式标记
        isEditingFromMain = false
        currentScreen = .main
    }
}
