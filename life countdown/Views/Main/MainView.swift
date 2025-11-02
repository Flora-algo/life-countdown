import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            
            // 背景色
            Color(red: 0.09, green: 0.13, blue: 0.20)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // 1️⃣ 顶部区域
                VStack(spacing: 20) {
                    
                    // 顶部栏：Logo + 标题 + 设置按钮
                    HStack(spacing: 12) {
                        
                        // Logo
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 20)
                        
                        // 标题
                        Text("Life Countdown")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                        
                        Spacer()
                        
                        // 设置按钮
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 0)  // 可以是 0，因为已经在安全区域内了
                    
                    // 倒计时区域
                    VStack(spacing: 8) {
                        
                        // 标题："第 301 个月 剩余"
                        Text("第 301 个月   剩余")
                            .font(.system(size: 14, weight: .light))
                            .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                        
                        // 倒计时数字：天、时、分、秒
                        HStack(spacing: 4) {  // ← 改小间距
                            
                            // 天
                            VStack(spacing: 4) {
                                Text("03")
                                    .font(.system(size: 45, weight: .ultraLight))
                                    .foregroundColor(.white)
                                Text("天")
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                            }
                            
                            // 冒号
                            Text(":")
                                .font(.system(size: 20, weight: .ultraLight))
                                .foregroundColor(Color(red: 31/255, green: 52/255, blue: 81/255))
                                .padding(.bottom, 16)  // 对齐数字，不对齐单位
                            
                            // 时
                            VStack(spacing: 4) {
                                Text("10")
                                    .font(.system(size: 45, weight: .ultraLight))
                                    .foregroundColor(.white)
                                Text("时")
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                            }
                            
                            // 冒号
                            Text(":")
                                .font(.system(size: 20, weight: .ultraLight))
                                .foregroundColor(Color(red: 31/255, green: 52/255, blue: 81/255))
                                .padding(.bottom, 16)
                            
                            // 分
                            VStack(spacing: 4) {
                                Text("59")
                                    .font(.system(size: 45, weight: .ultraLight))
                                    .foregroundColor(.white)
                                Text("分")
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                            }
                            
                            // 冒号
                            Text(":")
                                .font(.system(size: 20, weight: .ultraLight))
                                .foregroundColor(Color(red: 31/255, green: 52/255, blue: 81/255))
                                .padding(.bottom, 16)
                            
                            // 秒
                            VStack(spacing: 4) {
                                Text("01")
                                    .font(.system(size: 45, weight: .ultraLight))
                                    .foregroundColor(Color(red: 0.478, green: 0.827, blue: 0.792))
                                Text("秒")
                                    .font(.system(size: 12, weight: .light))
                                    .foregroundColor(Color(red: 63/255, green: 72/255, blue: 88/255))
                            }
                        }
                        .padding(.bottom, 20)
                        
                        Spacer()
                    }
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .background(Color.red.opacity(0.2))
                    
                    // 2️⃣ 中间区域
                    ScrollView {
                        LifeGridView()
                    }
                    .background(Color.green.opacity(0.2))
                    
                    // 3️⃣ 底部区域
                    VStack {
                        Text("底部：进度条")
                            .foregroundColor(.white)
                    }
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.opacity(0.2))
                    
                }
            }
        }
    }
}
#Preview {
    MainView()
}
