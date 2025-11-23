import SwiftUI

struct AgeInputView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    
    let years = Array((1900...Calendar.current.component(.year, from: Date())).reversed())
    let months = Array(1...12)
    
    // 设备检测
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // ✨ 改进：动态缩放倍数
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
    
    // Picker 文字大小
    private var pickerFontSize: CGFloat {
        if isIPad {
            return 20 * 1.3
        } else {
            return 20
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
                    // ✨ 顶部空白（屏幕高度的 18%）
                    Spacer()
                        .frame(height: geometry.size.height * 0.25)
                    
                    // 标题
                    Text("age_input_title".localized())
                        .font(.system(size: 22 * scaleFactor, weight: .ultraLight))
                        .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                    
                    // ✨ 标题到 Picker 的间距（屏幕高度的 7%）
                    Spacer()
                        .frame(height: geometry.size.height * 0.07)
                    
                    // 自定义日期选择器
                    HStack(spacing: 0) {
                        // 年份
                        Picker("", selection: $selectedYear) {
                            ForEach(years, id: \.self) { year in
                                Text(verbatim: "\(year)")
                                    .font(.system(size: pickerFontSize))
                                    .foregroundColor(Color(red: 82/255, green: 100/255, blue: 126/255))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 120 * scaleFactor)
                        .clipped()

                        // 月份
                        Picker("", selection: $selectedMonth) {
                            ForEach(months, id: \.self) { month in
                                Text(verbatim: "\(month)")
                                    .font(.system(size: pickerFontSize))
                                    .foregroundColor(Color(red: 82/255, green: 100/255, blue: 126/255))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 80 * scaleFactor)
                        .clipped()
                    }
                    
                    // ✨ Picker 到按钮的间距（屏幕高度的 7%）
                    Spacer()
                        .frame(height: geometry.size.height * 0.09)
                    
                    // 前进按钮
                    NavigationButton {
                        if let date = createDate(year: selectedYear, month: selectedMonth) {
                            appState.birthDate = date
                        }
                        appState.navigateToLifespanInput()
                    }
                    
                    // 弹性空白（自动填充剩余空间）
                    Spacer()
                    
                    // Logo（距底部固定距离）
                    LogoView(scale: 0.74)
                        .padding(.bottom, 28 * scaleFactor)
                }
                .colorScheme(.dark)
                .environment(\.locale, Locale(identifier: "en_US"))
                
                // 返回按钮（浮动）
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
            let components = Calendar.current.dateComponents([.year, .month], from: appState.birthDate)
            if let year = components.year, let month = components.month {
                selectedYear = year
                selectedMonth = month
            }
        }
    }
    
    func createDate(year: Int, month: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        return Calendar.current.date(from: components)
    }
}

#Preview {
    let appState = AppState()
    appState.isEditingFromMain = true
    
    return AgeInputView()
        .environmentObject(appState)
}
