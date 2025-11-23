import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: MainViewModel
    @ObservedObject var languageManager = LanguageManager.shared
    @State private var showAboutAlert = false
    @State private var isBreathing = false
    
    // ✨ 新增：设备检测
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // ✨ 新增：缩放倍数
    private var scaleFactor: CGFloat {
        isIPad ? 1.8 : 1.0
    }

    // 计算 LifeGridView 的实际高度
    private func lifeGridHeight(geometry: GeometryProxy) -> CGFloat {
        let totalMonths = viewModel.totalMonths
        let dotsPerRow = 24
        let rows = Int(ceil(Double(totalMonths) / Double(dotsPerRow)))
        let dotSize: CGFloat = 5 * scaleFactor

        let availableWidth = min(geometry.size.width * 0.85, 450)
        let calculatedSpacing = (availableWidth - CGFloat(dotsPerRow) * dotSize) / CGFloat(dotsPerRow - 1)
        let spacing = max(calculatedSpacing, 9 * scaleFactor)

        let totalHeight = CGFloat(rows) * dotSize + CGFloat(rows - 1) * spacing
        return totalHeight + 30 // 加上 padding (top 15 + bottom 15)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // 背景色
                Color(red: 0.09, green: 0.13, blue: 0.20)
                    .ignoresSafeArea()
                
                // 星光背景
                StarBackgroundView()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    
                    // 1️⃣ 顶部区域 - 固定内容
                    VStack(spacing: 20) {
                        
                        // 顶部栏：Logo + 标题 + 设置按钮
                        HStack(spacing: 12) {
                            
                            // Logo + 标题（可点击）
                            LogoView()
                                .onTapGesture {
                                    showAboutAlert = true
                                }
                            
                            Spacer()
                            
                            // 设置按钮
                            Button(action: {
                                appState.navigateToLanguageSelectionFromMain()
                            }) {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 20 * scaleFactor))  // ← 修改：图标大小缩放
                                    .foregroundColor(Color(red: 50/255, green: 65/255, blue: 80/255))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 倒计时区域
                        VStack(spacing: 10 * scaleFactor) {  // ← 修改：间距缩放
                            
                            // 标题
                            Text(viewModel.titleText)
                                .font(.system(size: 14 * scaleFactor, weight: .ultraLight))  // ← 修改：字体缩放
                                .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                            
                            // 倒计时数字
                            HStack(spacing: 4 * scaleFactor) {  // ← 修改：间距缩放
                                
                                // 天
                                VStack(spacing: 4 * scaleFactor) {  // ← 修改：间距缩放
                                    Text(String(format: "%02d", viewModel.remainingDays))
                                        .font(.system(size: 45 * scaleFactor, weight: .ultraLight))  // ← 修改：字体缩放
                                        .foregroundColor(.white)
                                        .monospacedDigit()
                                    Text("time_unit_days".localized())
                                        .font(.system(size: 12 * scaleFactor, weight: .light))  // ← 修改：字体缩放
                                        .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                                }
                                
                                Text(":")
                                    .font(.system(size: 20 * scaleFactor, weight: .light))  // ← 修改：字体缩放
                                    .foregroundColor(Color(red: 60/255, green: 75/255, blue: 90/255))
                                    .padding(.bottom, 16 * scaleFactor)  // ← 修改：padding 缩放
                                
                                // 时
                                VStack(spacing: 4 * scaleFactor) {  // ← 修改：间距缩放
                                    Text(String(format: "%02d", viewModel.remainingHours))
                                        .font(.system(size: 45 * scaleFactor, weight: .ultraLight))  // ← 修改：字体缩放
                                        .foregroundColor(.white)
                                        .monospacedDigit()
                                    Text("time_unit_hours".localized())
                                        .font(.system(size: 12 * scaleFactor, weight: .light))  // ← 修改：字体缩放
                                        .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                                }
                                
                                Text(":")
                                    .font(.system(size: 20 * scaleFactor, weight: .light))  // ← 修改：字体缩放
                                    .foregroundColor(Color(red: 60/255, green: 75/255, blue: 90/255))
                                    .padding(.bottom, 16 * scaleFactor)  // ← 修改：padding 缩放
                                
                                // 分
                                VStack(spacing: 4 * scaleFactor) {  // ← 修改：间距缩放
                                    Text(String(format: "%02d", viewModel.remainingMinutes))
                                        .font(.system(size: 45 * scaleFactor, weight: .ultraLight))  // ← 修改：字体缩放
                                        .foregroundColor(.white)
                                        .monospacedDigit()
                                    Text("time_unit_minutes".localized())
                                        .font(.system(size: 12 * scaleFactor, weight: .light))  // ← 修改：字体缩放
                                        .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                                }
                                
                                Text(":")
                                    .font(.system(size: 25 * scaleFactor, weight: .light))  // ← 修改：字体缩放
                                    .foregroundColor(Color(red: 60/255, green: 75/255, blue: 90/255))
                                    .padding(.bottom, 16 * scaleFactor)  // ← 修改：padding 缩放
                                
                                // 秒
                                VStack(spacing: 4 * scaleFactor) {  // ← 修改：间距缩放
                                    Text(String(format: "%02d", viewModel.remainingSeconds))
                                        .font(.system(size: 45 * scaleFactor, weight: .ultraLight))  // ← 修改：字体缩放
                                        .foregroundColor(Color(red: 0.478, green: 0.827, blue: 0.792))
                                        .shadow(
                                            color: Color(red: 0.7, green: 0.9, blue: 0.88).opacity(0.9),
                                            radius: isBreathing ? (10 * scaleFactor) : (3 * scaleFactor),  // ← 修改：阴影半径缩放
                                            x: 0,
                                            y: 0
                                        )
                                        .monospacedDigit()
                                    Text("time_unit_seconds".localized())
                                        .font(.system(size: 12 * scaleFactor, weight: .light))  // ← 修改：字体缩放
                                        .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                                }
                            }
                        }
                    }
                    .padding(.top, geometry.safeAreaInsets.top > 0 ? 1 : 60)
                    
                    // 间隔
                    Color.clear.frame(height: 10)
                    
                    // 2️⃣ 中间区域 - 点阵（自动填充）

                    ScrollView {
                        LifeGridView(
                            totalMonths: viewModel.totalMonths,
                            currentMonth: viewModel.currentMonth
                        )
                        .padding(.top, 15)
                        .padding(.bottom, 15)
                        .frame(height: lifeGridHeight(geometry: geometry))
                    }
                    
                    // 间隔
                    Color.clear.frame(height: 25)
                    
                    // 3️⃣ 底部区域 - 进度条
                    ProgressBarView(
                        currentMonth: viewModel.currentMonth,
                        totalMonths: viewModel.totalMonths
                    )
                    .padding(.bottom, geometry.safeAreaInsets.bottom > 0 ? 10 : 30)
                }
                
                // 弹窗
                if showAboutAlert {
                    AboutAlertView(isPresented: $showAboutAlert)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.2), value: showAboutAlert)
                }
            }
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                isBreathing = true
            }
        }
    }
}
#Preview {
    let birthDate = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
    let viewModel = MainViewModel(birthDate: birthDate, userLifespan: 80)
    
    MainView(viewModel: viewModel)
        .environmentObject(AppState())
}
