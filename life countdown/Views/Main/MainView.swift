import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: MainViewModel
    @State private var showAboutAlert = false
    @State private var isBreathing = false  // ← 添加这行
    
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
                            HStack(spacing: 12) {
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 20)
                                
                                Text("Life Countdown")
                                    .font(.system(size: 16, weight: .ultraLight))
                                    .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                            }
                            .onTapGesture {
                                showAboutAlert = true
                            }
                            
                            Spacer()
                            
                            // 设置按钮
                            Button(action: {
                                appState.navigateToAgeInput()
                            }) {
                                Image(systemName: "gearshape")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(red: 50/255, green: 65/255, blue: 80/255))
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // 倒计时区域
                        VStack(spacing: 10) {
                            
                            // 标题
                            Text(viewModel.titleText)
                                .font(.system(size: 14, weight: .ultraLight))
                                .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                            
                            // 倒计时数字
                            HStack(spacing: 4) {
                                
                                // 天
                                VStack(spacing: 4) {
                                    Text(String(format: "%02d", viewModel.remainingDays))
                                        .font(.system(size: 45, weight: .ultraLight))
                                        .foregroundColor(.white)
                                        .monospacedDigit()
                                    Text("天")
                                        .font(.system(size: 12, weight: .light))
                                        .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                                }
                                
                                Text(":")
                                    .font(.system(size: 20, weight: .light))
                                    .foregroundColor(Color(red: 60/255, green: 75/255, blue: 90/255))
                                    .padding(.bottom, 16)
                                
                                // 时
                                VStack(spacing: 4) {
                                    Text(String(format: "%02d", viewModel.remainingHours))
                                        .font(.system(size: 45, weight: .ultraLight))
                                        .foregroundColor(.white)
                                        .monospacedDigit()
                                    Text("时")
                                        .font(.system(size: 12, weight: .light))
                                        .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                                }
                                
                                Text(":")
                                    .font(.system(size: 20, weight: .light))
                                    .foregroundColor(Color(red: 60/255, green: 75/255, blue: 90/255))
                                    .padding(.bottom, 16)
                                
                                // 分
                                VStack(spacing: 4) {
                                    Text(String(format: "%02d", viewModel.remainingMinutes))
                                        .font(.system(size: 45, weight: .ultraLight))
                                        .foregroundColor(.white)
                                        .monospacedDigit()
                                    Text("分")
                                        .font(.system(size: 12, weight: .light))
                                        .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                                }
                                
                                Text(":")
                                    .font(.system(size: 25, weight: .light))
                                    .foregroundColor(Color(red: 60/255, green: 75/255, blue: 90/255))
                                    .padding(.bottom, 16)
                                
                                // 秒
                                VStack(spacing: 4) {
                                    Text(String(format: "%02d", viewModel.remainingSeconds))
                                        .font(.system(size: 45, weight: .ultraLight))
                                        .foregroundColor(Color(red: 0.478, green: 0.827, blue: 0.792))
                                        .shadow(
                                            color: Color(red: 0.7, green: 0.9, blue: 0.88).opacity(0.9),
                                            radius: isBreathing ? 10 : 3,
                                            x: 0,
                                            y: 0
                                        )
                                        .monospacedDigit()
                                    Text("秒")
                                        .font(.system(size: 12, weight: .light))
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
