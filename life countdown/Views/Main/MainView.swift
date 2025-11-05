import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: MainViewModel
    @State private var showAboutAlert = false
    @State private var isBreathing = false  // ← 添加这行
    
    var body: some View {
        ZStack {
            // 背景色
            Color(red: 0.09, green: 0.13, blue: 0.20)
                .ignoresSafeArea()
            
            // 星光背景
                    StarBackgroundView()
                        .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 1️⃣ 顶部区域
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
                    .padding(.top,0)
                    
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
                                    .monospacedDigit()  // ← 添加这行
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
                                    .monospacedDigit()  // ← 添加这行
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
                                    .monospacedDigit()  // ← 添加这行
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
                                                color: Color(red: 0.478, green: 0.827, blue: 0.792).opacity(0.8),
                                                radius: isBreathing ? 10 : 3,  // ← 改成动态的
                                                x: 0,
                                                y: 0
                                            )
                                    .monospacedDigit()  // ← 添加这行
                                Text("秒")
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                            }
                        }
                    }
                    
                }
                .frame(height: 155)
                .frame(maxWidth: .infinity)
                
              
                // 2️⃣ 中间区域
                VStack(spacing: 0) {
                    // 固定的顶部间距（在 ScrollView 外面）
                    Color.clear
                        .frame(height: 11)
                    
                    // 可滚动的点阵
                    ScrollView {
                        LifeGridView(
                            totalMonths: viewModel.totalMonths,
                            currentMonth: viewModel.currentMonth
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                    }
                }
                .frame(height: 558)
                
                // 3️⃣ 底部区域
                VStack {
                    Spacer()
                    ProgressBarView(
                        currentMonth: viewModel.currentMonth,
                        totalMonths: viewModel.totalMonths
                    )
                    Spacer()
                }
                .frame(height: 53)
                .frame(maxWidth: .infinity)
            }
            
            // 弹窗
            if showAboutAlert {
                AboutAlertView(isPresented: $showAboutAlert)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: showAboutAlert)
            }
        }
        .onAppear {
                   // 启动呼吸动画
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
    
    return MainView(viewModel: viewModel)
        .environmentObject(AppState())
}
