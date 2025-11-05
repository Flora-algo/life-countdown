import SwiftUI

struct NumberInputField: View {
    @Binding var text: String
    let placeholder: String
    let unit: String
    
    @FocusState private var isFocused: Bool  // ← 添加焦点状态
    
    var body: some View {
        ZStack {
            
            // 下划线（基准，居中）
            Rectangle()
                .fill(Color(red: 31/255, green: 52/255, blue: 81/255))
                .frame(width: 152, height: 1)
                .offset(y: 11)
            
            // 输入框（在下划线上方，居中对齐）
            ZStack {
                // 自定义 placeholder - 只在未聚焦且为空时显示
                if text.isEmpty && !isFocused {  // ← 改这里
                    Text(placeholder)
                        .font(.system(size: 32, weight: .thin))
                        .foregroundColor(Color(red: 82/255, green: 100/255, blue: 126/255))
                        .allowsHitTesting(false)
                }
                
                TextField("", text: $text)
                    .font(.system(size: 32, weight: .thin))
                    .foregroundColor(Color(red: 82/255, green: 100/255, blue: 126/255))
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .accentColor(Color(red: 55/255.0, green: 85/255.0, blue: 110/255.0))
                    .focused($isFocused)  // ← 添加这行
            }
            .frame(width: 152, height: 40)
            .offset(y: -20)
            
            // 单位文字（在下划线右边，和输入框垂直居中对齐）
            Text(unit)
                .font(.system(size: 16, weight: .light))
                .foregroundColor(Color(red: 82/255, green: 100/255, blue: 126/255))
                .offset(x: 76 + 14, y: -20)
        }
        .frame(width: 200, height: 60)
    }
}

#Preview {
    ZStack {
        Color(red: 0.09, green: 0.13, blue: 0.20)
            .ignoresSafeArea()
        
        NumberInputField(
            text: .constant(""),
            placeholder: "age",
            unit: "岁"
        )
    }
}
