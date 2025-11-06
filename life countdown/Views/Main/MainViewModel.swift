import SwiftUI
import Combine

class MainViewModel: ObservableObject {
    // 用户数据
    @Published var birthDate: Date
    @Published var userLifespan: Int
    
    // 计算属性
    @Published var currentMonth: Int = 0
    @Published var totalMonths: Int = 0
    @Published var remainingDays: Int = 0
    @Published var remainingHours: Int = 0
    @Published var remainingMinutes: Int = 0
    @Published var remainingSeconds: Int = 0
    
    // 定时器
    private var timer: Timer?
    
    // 初始化
    init(birthDate: Date, userLifespan: Int) {
        print("MainViewModel init")
        print("接收到的生日: \(birthDate)")
        print("接收到的寿命: \(userLifespan)")
        
        self.birthDate = birthDate
        self.userLifespan = userLifespan
        
        // 初始计算
        self.calculateAll()
        
        print("当前月数: \(currentMonth)")
        print("总月数: \(totalMonths)")
        print("剩余天数: \(remainingDays)")
        print("剩余小时: \(remainingHours)")
        print("剩余分钟: \(remainingMinutes)")
        print("剩余秒数: \(remainingSeconds)")
        
        // 启动定时器
        self.startTimer()
        print("定时器已启动")
    }
    
    // 计算所有数据
    func calculateAll() {
        let calendar = Calendar.current
        let now = Date()
        
        // 计算总月数
        totalMonths = userLifespan * 12
        
        // 计算当前是第几个月（从出生到现在）
        let components = calendar.dateComponents([.month], from: birthDate, to: now)
        currentMonth = components.month ?? 0
        
        // 获取当前日期的年月
        let nowComponents = calendar.dateComponents([.year, .month], from: now)
        
        // 构建下个月1日 00:00:00 的日期
        var nextMonthComponents = DateComponents()
        nextMonthComponents.year = nowComponents.year
        nextMonthComponents.month = (nowComponents.month ?? 1) + 1
        nextMonthComponents.day = 1
        nextMonthComponents.hour = 0
        nextMonthComponents.minute = 0
        nextMonthComponents.second = 0
        
        // 计算当前自然月的结束时间（下个月1日 00:00:00）
        let currentMonthEndDate = calendar.date(from: nextMonthComponents) ?? Date()
        
        // 计算距离当前月结束的剩余时间
        let remaining = calendar.dateComponents([.day, .hour, .minute, .second], from: now, to: currentMonthEndDate)
        
        remainingDays = max(0, remaining.day ?? 0)
        remainingHours = max(0, remaining.hour ?? 0)
        remainingMinutes = max(0, remaining.minute ?? 0)
        remainingSeconds = max(0, remaining.second ?? 0)
        
        print("calculateAll 更新完成 - 当前月:\(currentMonth), 剩余秒数: \(remainingSeconds)")
    }
        
        // 启动定时器（每秒更新）
        func startTimer() {
            // 确保在主线程创建 Timer
            DispatchQueue.main.async { [weak self] in
                self?.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                    self?.calculateAll()
                }
                // 添加到 RunLoop
                if let timer = self?.timer {
                    RunLoop.main.add(timer, forMode: .common)
                }
                print("定时器已启动")
            }
        }
    
    // 停止定时器
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // 进度百分比
    var progress: Double {
        guard totalMonths > 0 else { return 0 }
        return Double(currentMonth + 1) / Double(totalMonths)
    }
    
    // 格式化的百分比文字
    var percentageText: String {
        let percentage = progress * 100
        return String(format: "%.1f%%", percentage)
    }
    
    // 格式化的分数文字
    var fractionText: String {
        return "\(currentMonth + 1)/\(totalMonths)"
    }
    
    // 格式化的标题文字
    var titleText: String {
        let remaining = totalMonths - currentMonth
        return "第 \(currentMonth + 1) 个月   剩余"
    }
    
    deinit {
        stopTimer()
    }
}
