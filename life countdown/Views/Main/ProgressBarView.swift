import SwiftUI

struct ProgressBarView: View {
    // 固定参数（后面会从 ViewModel 获取）
    let currentMonth: Int      // ← 不要赋值
    let totalMonths: Int       // ← 不要赋值
    
    @State private var isBreathing = false  // ← 添加这行
    
    // 点阵的宽度（用于对齐）
    let gridWidth: CGFloat = 327
    
    
    var body: some View {
        HStack(spacing: 10) {
            
            // 进度条
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 背景（未完成部分）
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 31/255, green: 52/255, blue: 81/255))
                        .frame(height: 4)
                    
                    // 前景（已完成部分）
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 122/255, green: 211/255, blue: 202/255))
                        .frame(width: geometry.size.width * progress, height: 4)
                        .shadow(
                                color: Color(red: 0.7, green: 0.9, blue: 0.88).opacity(0.9),
                                radius: isBreathing ? 8 : 4,
                                x: 0,
                                y: 0
                            )
                }
            }
            .frame(height: 4)
            
            // 百分比
            Text(String(format: "%.1f%%", progress * 100))
                .font(.system(size: 14, weight: .ultraLight))
                .foregroundColor(Color(red: 85/255, green: 147/255, blue: 144/255))
                .fixedSize()  // 固定大小，不压缩
            
            // 分数
            Text("\(currentMonth)/\(totalMonths)")
                .font(.system(size: 14, weight: .ultraLight))
                .foregroundColor(Color(red: 83/255, green: 92/255, blue: 108/255))
                .fixedSize()  // 固定大小，不压缩
        }
        .frame(width: gridWidth)  // 总宽度和点阵一致
        .padding(.horizontal, 20)  // 左右边距
        .onAppear {
                withAnimation(
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
                ) {
                    isBreathing = true
                }
            }
    }
    
    // 计算进度百分比
    var progress: Double {
        return Double(currentMonth) / Double(totalMonths)
    }
    
}

#Preview {
    ZStack {
        Color(red: 0.09, green: 0.13, blue: 0.20)
            .ignoresSafeArea()
        
        ProgressBarView(currentMonth: 300, totalMonths: 960)
    }
}
