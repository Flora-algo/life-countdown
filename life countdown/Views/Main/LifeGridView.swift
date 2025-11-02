import SwiftUI

struct LifeGridView: View {
    // 固定参数（后面会从 ViewModel 获取）
    let totalMonths = 960      // 80 岁 × 12 个月
    let currentMonth = 300     // 假设已过 300 个月（25 岁）
    let dotsPerRow = 24        // 每行 24 个点
    
    // 点的样式参数
    let dotSize: CGFloat = 5
    let spacing: CGFloat = 9
    
    var body: some View {
        VStack(spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<dotsPerRow, id: \.self) { col in
                        let index = row * dotsPerRow + col
                        
                        if index < totalMonths {
                            DotView(
                                index: index,
                                currentMonth: currentMonth,
                                totalMonths: totalMonths,
                                row: row,
                                totalRows: rows,
                                dotSize: dotSize
                            )
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 194)      // 距离顶部 194
    }
    
    // 计算总行数
    var rows: Int {
        Int(ceil(Double(totalMonths) / Double(dotsPerRow)))
    }
}

struct DotView: View {
    let index: Int
    let currentMonth: Int
    let totalMonths: Int
    let row: Int
    let totalRows: Int
    let dotSize: CGFloat
    
    var body: some View {
        Circle()
            .fill(dotColor)
            .frame(width: actualDotSize, height: actualDotSize)  // ← 改用 actualDotSize
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 0)
    }
    
    // 实际点的大小（当前点更大）
    var actualDotSize: CGFloat {
        if index == currentMonth {
            return 10  // 当前点：10
        } else {
            return dotSize  // 其他点：5
        }
    }
    
    // 点的颜色
    var dotColor: Color {
        if index < currentMonth {
            // 已过的点：渐变（从上往下越来越亮）
            let progress = Double(row) / Double(totalRows)
            return Color(
                red: 0.231 + progress * 0.3,
                green: 0.345 + progress * 0.3,
                blue: 0.373 + progress * 0.3
            )
        } else if index == currentMonth {
            // 当前点：最亮
            return Color(red: 231/255, green: 243/255, blue: 242/255)
        } else {
            // 未来的点：深色 + 随机
            let randomVariation = Double.random(in: -0.02...0.02)
            return Color(
                red: 31/255 + randomVariation,
                green: 40/255 + randomVariation,
                blue: 53/255 + randomVariation
            )
        }
    }
    
    // 光晕效果（只有当前点有）
    var shadowColor: Color {
        if index == currentMonth {
            return Color(red: 231/255, green: 243/255, blue: 242/255).opacity(0.8)
        } else {
            return Color.clear
        }
    }
    
    var shadowRadius: CGFloat {
        if index == currentMonth {
            return 4
        } else {
            return 0
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.09, green: 0.13, blue: 0.20)
            .ignoresSafeArea()
        
        ScrollView {
            LifeGridView()
        }
    }
}
