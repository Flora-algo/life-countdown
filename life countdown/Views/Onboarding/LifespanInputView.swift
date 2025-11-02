import SwiftUI

// 寿命输入页
struct LifespanInputView: View {
    @State private var lifespan: String = ""  // 存储用户输入的寿命
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // 背景色
            Color(red: 0.09, green: 0.13, blue: 0.20)
                .ignoresSafeArea()
            
            // 标题 "预期的生命长度"
            Text("预期的生命长度")
                .font(.system(size: 22, weight: .light))
                .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                .offset(x: 125, y: 234)  // 274 - 40 = 234
            
            // 输入框（带 placeholder "age"）
            TextField("age", text: $lifespan)
                .font(.system(size: 32, weight: .ultraLight))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .frame(width: 152, height: 40)
                .background(Color.clear)
                .offset(x: 120, y: 353)  // 393 - 40 = 353
                .accentColor(.white)
                .overlay(
                    Group {
                        if lifespan.isEmpty {
                            Text("age")
                                .font(.system(size: 32, weight: .ultraLight))
                                .foregroundColor(Color(red: 0.34, green: 0.47, blue: 0.52))
                                .offset(x: 120, y: 353)  // 393 - 40 = 353
                                .allowsHitTesting(false)
                        }
                    }
                )
            
            // 下划线
            Rectangle()
                .fill(Color(red: 0.34, green: 0.47, blue: 0.52))
                .frame(width: 152, height: 1)
                .offset(x: 120, y: 404)  // 444 - 40 = 404
            
            // "岁" 文字
            Text("岁")
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                .offset(x: 286, y: 361)  // 401 - 40 = 361
            
            // 前进符号 "››"
            Text("››")
                .font(.system(size: 34, weight: .ultraLight))
                .foregroundColor(Color(red: 0.34, green: 0.47, blue: 0.52))
                .offset(x: 179, y: 467)  // 507 - 40 = 467
        }
    }
}

#Preview {
    LifespanInputView()
}
