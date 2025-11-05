import SwiftUI

struct LifeGridView: View {
    let totalMonths: Int       // ← 从外部传入
    let currentMonth: Int      // ← 从外部传入
    let dotsPerRow = 24
    
    // 点的样式参数
    let dotSize: CGFloat = 5
    let spacing: CGFloat = 9
    
    var body: some View {
        HStack {
            Spacer()  // 左边 Spacer
            
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
                        
                        if row == rows - 1 && totalMonths % dotsPerRow != 0 {
                            Spacer(minLength: 0)
                        }
                    }
                    .frame(width: fullRowWidth, alignment: .leading)
                }
            }
            
            Spacer()  // 右边 Spacer
        }
    }

    var fullRowWidth: CGFloat {
        CGFloat(dotsPerRow) * dotSize + CGFloat(dotsPerRow - 1) * spacing
        // 24 * 5 + 23 * 9 = 120 + 207 = 327
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
    
    @State private var isBreathing = false  // ← 添加呼吸状态
    
    var body: some View {
        Circle()
            .fill(index == currentMonth ? Color.clear : dotColor)  // 当前月的基础圆透明
            .frame(width: dotSize, height: dotSize)  // 所有点都占用 5x5 的布局空间
            .overlay {
                // 当前月用 10x10 的大圆覆盖（溢出但不占空间）
                if index == currentMonth {
                    Circle()
                        .fill(dotColor)
                        .frame(width: 10, height: 10)
                        .scaleEffect(isBreathing ? 1.0 : 0.65)  // ← 呼吸缩放
                        .shadow(color: shadowColor,
                                radius: isBreathing ? 6 : 2,  // ← 光晕跟着呼吸
                                x: 0,
                                y: 0
                        )
                }
            }
            .onAppear {
                            // 只对当前月启动呼吸动画
                            if index == currentMonth {
                                withAnimation(
                                    .easeInOut(duration: 1.5)  // 1.5秒一个呼吸周期
                                    .repeatForever(autoreverses: true)  // 无限循环，自动反转
                                ) {
                                    isBreathing = true
                                }
                            }
                        }
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
            let progress = Double(index) / Double(currentMonth)
                return Color(
                    red: 30/255 + progress * 91/255,   // 从 30 渐变到 121
                    green: 60/255 + progress * 150/255, // 从 60 渐变到 210
                    blue: 65/255 + progress * 136/255  // 从 65 渐变到 201
            )
        } else if index == currentMonth {
            // 当前点：最亮
            return Color(red: 231/255, green: 243/255, blue: 242/255)
        } else {
            // 未来的点：深色 + 随机（稍微提亮）
            let randomVariation = Double.random(in: -0.06...0.06)
            return Color(
                red: 58/255 + randomVariation,   // 从 50 改成 58
                green: 73/255 + randomVariation,  // 从 65 改成 73
                blue: 93/255 + randomVariation   // 从 85 改成 93
            )
        }
    }
    
    // 光晕效果（只有当前点有）
    var shadowColor: Color {
        if index == currentMonth {
            return Color.white.opacity(0.9)  // ← 改成纯白色，更亮
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
            LifeGridView(totalMonths: 960, currentMonth: 300)
        }
    }
}
