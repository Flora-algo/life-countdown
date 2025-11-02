import SwiftUI

// 年龄输入页
struct AgeInputView: View {
    @State private var age: String = ""  // 存储用户输入的年龄
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // 背景色
            Color(red: 0.09, green: 0.13, blue: 0.20)
                .ignoresSafeArea()
            
            // 标题 "你现在的年龄"
            Text("你现在的年龄")
                .font(.system(size: 22, weight: .light))
                .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                .offset(x: 135, y: 234)
            
            // 输入框（带 placeholder "age"）
            TextField("age", text: $age)
                .font(.system(size: 32, weight: .ultraLight))
                .foregroundColor(.white)  // 输入的数字是白色
                .multilineTextAlignment(.center)  // 居中对齐
                .keyboardType(.numberPad)  // 数字键盘
                .frame(width: 152, height: 40)
                .background(Color.clear)  // 背景透明（和页面背景同色）
                .offset(x: 120, y: 353)
                // 自定义 placeholder 颜色和样式
                .accentColor(.white)  // 光标颜色
                .overlay(
                    // 当输入框为空时，显示自定义的 placeholder
                    Group {
                        if age.isEmpty {
                            Text("age")
                                .font(.system(size: 32, weight: .ultraLight))
                                .foregroundColor(Color(red: 0.34, green: 0.47, blue: 0.52))
                                .offset(x: 120, y: 353)
                                .allowsHitTesting(false)  // 不阻挡点击
                        }
                    }
                )
            
            // 下划线（固定，始终显示）
            Rectangle()
                .fill(Color(red: 0.34, green: 0.47, blue: 0.52))
                .frame(width: 152, height: 1)
                .offset(x: 120, y: 404)
            
            // "岁" 文字
            Text("岁")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                .offset(x: 286, y: 361)
            
            // 前进符号 "››"
            Text("››")
                .font(.system(size: 34, weight: .ultraLight))
                .foregroundColor(Color(red: 0.34, green: 0.47, blue: 0.52))
                .offset(x: 179, y: 467
                )
        }
    }
}

#Preview {
    AgeInputView()
}
