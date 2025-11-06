import SwiftUI

struct AgeInputView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    
    let years = Array((1900...Calendar.current.component(.year, from: Date())).reversed())
    let months = Array(1...12)
    
    var body: some View {
        ZStack {
            // 背景色
            Color(red: 0.09, green: 0.13, blue: 0.20)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 顶部空白
                Spacer()
                    .frame(height: 160)
                
                // 标题
                Text("你的出生日期")
                    .font(.system(size: 22, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                
                Spacer()
                    .frame(height: 60)
                
                // 自定义日期选择器
                HStack(spacing: 0) {
                    // 年份
                    Picker("", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(verbatim: "\(year)年")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 82/255, green: 100/255, blue: 126/255))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 120)
                    .clipped()
                    
                    // 月份
                    Picker("", selection: $selectedMonth) {
                        ForEach(months, id: \.self) { month in
                            Text("\(month)月")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 82/255, green: 100/255, blue: 126/255))
                                .multilineTextAlignment(.center)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 80)
                    .clipped()
                }
                .colorScheme(.dark)
                .environment(\.locale, Locale(identifier: "en_US"))
                
                Spacer()
                    .frame(height: 60)
                
                // 前进按钮
                NavigationButton {
                    // 保存生日（日期统一设为1日）
                    if let date = createDate(year: selectedYear, month: selectedMonth) {
                        appState.birthDate = date
                    }
                    appState.navigateToLifespanInput()
                }
                
                // 弹性空白（自动填充）
                Spacer()
                
                // Logo（在底部）
                LogoView(scale: 0.74)
                    .padding(.bottom, 28)  // 距离底部50
            }
        }
        .onAppear {
            // 恢复之前的选择（只恢复年月）
            let components = Calendar.current.dateComponents([.year, .month], from: appState.birthDate)
            if let year = components.year, let month = components.month {
                selectedYear = year
                selectedMonth = month
            }
        }
    }
    
    // 创建日期（日期固定为1日）
    func createDate(year: Int, month: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        return Calendar.current.date(from: components)
    }
}

#Preview {
    AgeInputView()
        .environmentObject(AppState())
}
