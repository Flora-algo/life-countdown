import SwiftUI

struct ProgressBarView: View {
    let currentMonth: Int
    let totalMonths: Int
    
    @State private var isBreathing = false
    
    let dotsPerRow = 24
    
    // ✨ 新增：设备检测
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // ✨ 新增：缩放倍数（和 LifeGridView 保持一致）
    private var scaleFactor: CGFloat {
        isIPad ? 1.8 : 1.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            let dotSize: CGFloat = 5 * scaleFactor  // ← 和 LifeGridView 一样
            let availableWidth = min(geometry.size.width * 0.85, 450)  // 和点阵保持一致
            let calculatedSpacing = (availableWidth - CGFloat(dotsPerRow) * dotSize) / CGFloat(dotsPerRow - 1)
            let spacing = max(calculatedSpacing, 9 * scaleFactor)  // ← 和 LifeGridView 一样
            let gridWidth = CGFloat(dotsPerRow) * dotSize + CGFloat(dotsPerRow - 1) * spacing
            
            HStack {
                Spacer()
                
                HStack(spacing: 10 * scaleFactor) {  // ← 间距缩放
                    
                    // 进度条
                    GeometryReader { barGeometry in
                        ZStack(alignment: .leading) {
                            // 背景
                            RoundedRectangle(cornerRadius: 20 * scaleFactor)  // ← 圆角缩放
                                .fill(Color(red: 31/255, green: 52/255, blue: 81/255))
                                .frame(height: 4 * scaleFactor)  // ← 高度缩放
                            
                            // 前景
                            RoundedRectangle(cornerRadius: 20 * scaleFactor)  // ← 圆角缩放
                                .fill(Color(red: 122/255, green: 211/255, blue: 202/255))
                                .frame(width: barGeometry.size.width * progress, height: 4 * scaleFactor)  // ← 高度缩放
                                .shadow(
                                    color: Color(red: 0.7, green: 0.9, blue: 0.88).opacity(0.9),
                                    radius: isBreathing ? (8 * scaleFactor) : (4 * scaleFactor),  // ← 阴影半径缩放
                                    x: 0,
                                    y: 0
                                )
                        }
                    }
                    .frame(height: 4 * scaleFactor)  // ← 高度缩放
                    
                    // 百分比
                    Text(String(format: "%.1f%%", progress * 100))
                        .font(.system(size: 14 * scaleFactor, weight: .ultraLight))  // ← 字体缩放
                        .foregroundColor(Color(red: 85/255, green: 147/255, blue: 144/255))
                        .fixedSize()
                    
                    // 分数
                    Text("\(currentMonth)/\(totalMonths)")
                        .font(.system(size: 14 * scaleFactor, weight: .ultraLight))  // ← 字体缩放
                        .foregroundColor(Color(red: 83/255, green: 92/255, blue: 108/255))
                        .fixedSize()
                }
                .frame(width: gridWidth)
                
                Spacer()
            }
        }
        .frame(height: 20 * scaleFactor)  // ← 给 GeometryReader 的高度也缩放
        .onAppear {
            withAnimation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
            ) {
                isBreathing = true
            }
        }
    }
    
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
