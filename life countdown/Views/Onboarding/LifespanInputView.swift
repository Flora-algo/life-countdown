import SwiftUI

// 寿命输入页
struct LifespanInputView: View {
    @EnvironmentObject var appState: AppState
    @State private var lifespan: String = ""  // 存储用户输入的寿命
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // 背景色
            Color(red: 0.09, green: 0.13, blue: 0.20)
                .ignoresSafeArea()
            
            // 标题（水平居中）
            HStack {
                Spacer()
                Text("预期的生命长度")
                    .font(.system(size: 22, weight: .ultraLight))
                    .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                Spacer()
            }
            .offset(x: 0, y: 234)
            
            // 输入框（水平居中）
            HStack {
                Spacer()
                NumberInputField(
                    text: $lifespan,
                    placeholder: "age",
                    unit: "岁"
                )
                Spacer()
            }
            .offset(x: 0, y: 353)  // 只控制垂直位置
            
            // 前进符号 "››"
            HStack {
                Spacer()
                NavigationButton {
                    if let lifespanValue = Int(lifespan) {
                        appState.userLifespan = lifespanValue
                    }
                    appState.navigateToMain()
                }
                Spacer()
            }
            .offset(x: 0, y: 467)
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
