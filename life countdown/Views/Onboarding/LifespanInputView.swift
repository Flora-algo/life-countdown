import SwiftUI

// 寿命输入页
struct LifespanInputView: View {
    @EnvironmentObject var appState: AppState
    @State private var lifespan: String = ""  // 存储用户输入的寿命
    
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
                Text("预期的生命长度")
                    .font(.system(size: 22, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                
                Spacer()
                    .frame(height: 133)
                
                // 输入框
                NumberInputField(
                    text: $lifespan,
                    placeholder: "age",
                    unit: "岁"
                )
                
                Spacer()
                    .frame(height: 134)
                
                // 前进按钮
                NavigationButton {
                    if let lifespanValue = Int(lifespan) {
                        appState.userLifespan = lifespanValue
                    }
                    appState.navigateToMain()
                }
                
                // 弹性空白（自动填充）
                Spacer()
                
                // Logo（在底部）
                LogoView(scale: 0.74)
                    .padding(.bottom, 28)
            }
        }
        .onAppear {
            // 只在用户之前输入过值时才恢复
            if appState.userLifespan > 0 && appState.userLifespan != 80 {
                lifespan = "\(appState.userLifespan)"
            }
        }
    }
}

#Preview {
    let appState = AppState()
    appState.userLifespan = 80  // 设置默认值
    
    return LifespanInputView()
        .environmentObject(appState)
}
