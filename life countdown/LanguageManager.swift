import Foundation
import SwiftUI

// 支持的语言
enum AppLanguage: String, CaseIterable {
    case english = "en"
    case traditionalChinese = "zh-Hant"
    case japanese = "ja"

    var displayName: String {
        switch self {
        case .english:
            return "English"
        case .traditionalChinese:
            return "繁體中文"
        case .japanese:
            return "日本語"
        }
    }

    var code: String {
        return self.rawValue
    }
}

// 语言管理器
class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: "selectedLanguage")
            // 更新 Bundle 的语言
            bundle = Bundle.main.path(forResource: currentLanguage.code, ofType: "lproj")
                .flatMap { Bundle(path: $0) } ?? Bundle.main
        }
    }

    private var bundle: Bundle = Bundle.main

    private init() {
        // 从 UserDefaults 读取保存的语言
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage"),
           let language = AppLanguage(rawValue: savedLanguage) {
            self.currentLanguage = language
        } else {
            // 默认使用日语（临时测试用）
            self.currentLanguage = .traditionalChinese
        }

        // 初始化 Bundle
        bundle = Bundle.main.path(forResource: currentLanguage.code, ofType: "lproj")
            .flatMap { Bundle(path: $0) } ?? Bundle.main
    }

    // 获取本地化字符串
    func localizedString(_ key: String) -> String {
        return bundle.localizedString(forKey: key, value: nil, table: nil)
    }

    // 切换语言
    func setLanguage(_ language: AppLanguage) {
        currentLanguage = language
    }

    // 检查是否已选择语言
    func hasSelectedLanguage() -> Bool {
        return UserDefaults.standard.string(forKey: "selectedLanguage") != nil
    }
}

// SwiftUI 扩展：方便在视图中使用本地化字符串
extension String {
    func localized() -> String {
        return LanguageManager.shared.localizedString(self)
    }
}
