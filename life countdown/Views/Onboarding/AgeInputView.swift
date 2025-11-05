import SwiftUI

struct AgeInputView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedDay: Int = Calendar.current.component(.day, from: Date())
    
    let years = Array((1900...Calendar.current.component(.year, from: Date())).reversed())
    let months = Array(1...12)
    let days = Array(1...31)
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // 背景色
            Color(red: 0.09, green: 0.13, blue: 0.20)
                .ignoresSafeArea()
            
            // 标题
            HStack {
                Spacer()
                Text("你的出生日期")
                    .font(.system(size: 22, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                Spacer()
            }
            .offset(x: 0, y: 234)
            
            // 自定义日期选择器
            HStack {
                Spacer()
                
                HStack(spacing: 0) {
                    // 年份
                    Picker("", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(verbatim: "\(year)年")  // ← 用 verbatim 强制原样输出
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
                    
                    // 日期
                    Picker("", selection: $selectedDay) {
                        ForEach(days, id: \.self) { day in
                            Text("\(day)日")
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
                .environment(\.locale, Locale(identifier: "en_US"))  // ← 添加这行
                
                Spacer()
            }
            .offset(x: 0, y: 300)
            
            // 前进按钮
            HStack {
                Spacer()
                NavigationButton {
                    // 保存生日
                    if let date = createDate(year: selectedYear, month: selectedMonth, day: selectedDay) {
                        appState.birthDate = date
                    }
                    appState.navigateToLifespanInput()
                }
                Spacer()
            }
            .offset(x: 0, y: 550)
        }
        .onAppear {
            // 恢复之前的选择
            let components = Calendar.current.dateComponents([.year, .month, .day], from: appState.birthDate)
            if let year = components.year, let month = components.month, let day = components.day {
                selectedYear = year
                selectedMonth = month
                selectedDay = day
            }
        }
    }
    
    // 创建日期
    func createDate(year: Int, month: Int, day: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = min(day, daysInMonth(year: year, month: month))
        return Calendar.current.date(from: components)
    }
    
    // 计算该月有多少天
    func daysInMonth(year: Int, month: Int) -> Int {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
}

#Preview {
    AgeInputView()
        .environmentObject(AppState())
}
