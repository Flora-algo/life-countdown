import SwiftUI

struct LifeGridView: View {
    let totalMonths: Int
    let currentMonth: Int
    let dotsPerRow = 24
    
    // ✨ 新增：设备检测
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // ✨ 新增：缩放倍数
    private var scaleFactor: CGFloat {
        isIPad ? 1.8 : 1.0
    }
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = min(geometry.size.width * 0.85, 450)
            let calculatedSpacing = (availableWidth - CGFloat(dotsPerRow) * (5 * scaleFactor)) / CGFloat(dotsPerRow - 1)  // ← 修改这里
            let spacing = max(calculatedSpacing, 9 * scaleFactor)  // ← 修改这里
            let dotSize: CGFloat = 5 * scaleFactor  // ← 修改这里
            
            HStack {
                Spacer()
                
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
                                        dotSize: dotSize,
                                        spacing: spacing
                                    )
                                }
                            }
                            
                            if row == rows - 1 && totalMonths % dotsPerRow != 0 {
                                Spacer(minLength: 0)
                            }
                        }
                        .frame(width: CGFloat(dotsPerRow) * dotSize + CGFloat(dotsPerRow - 1) * spacing, alignment: .leading)
                    }
                }
                
                Spacer()
            }
        }
    }
    
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
    let spacing: CGFloat
    
    @State private var isBreathing = false
    
    var body: some View {
        Circle()
            .fill(index == currentMonth ? Color.clear : dotColor)
            .frame(width: dotSize, height: dotSize)
            .overlay {
                if index == currentMonth {
                    Circle()
                        .fill(dotColor)
                        .frame(width: currentDotSize, height: currentDotSize)
                        .scaleEffect(isBreathing ? 1.0 : 0.65)
                        .shadow(
                            color: shadowColor,
                            radius: isBreathing ? 6 : 2,
                            x: 0,
                            y: 0
                        )
                }
            }
            .onAppear {
                if index == currentMonth {
                    withAnimation(
                        .easeInOut(duration: 1.5)
                        .repeatForever(autoreverses: true)
                    ) {
                        isBreathing = true
                    }
                }
            }
    }
    
    // 当前点的大小根据间距调整
    var currentDotSize: CGFloat {
        min(dotSize * 2 + spacing * 0.3, 12)
    }
    
    var dotColor: Color {
        if index < currentMonth {
            let progress = Double(index) / Double(currentMonth)
            return Color(
                red: 30/255 + progress * 91/255,
                green: 60/255 + progress * 150/255,
                blue: 65/255 + progress * 136/255
            )
        } else if index == currentMonth {
            return Color(red: 231/255, green: 243/255, blue: 242/255)
        } else {
            let randomVariation = Double.random(in: -0.06...0.06)
            return Color(
                red: 58/255 + randomVariation,
                green: 73/255 + randomVariation,
                blue: 93/255 + randomVariation
            )
        }
    }
    
    var shadowColor: Color {
        if index == currentMonth {
            return Color.white.opacity(0.9)
        } else {
            return Color.clear
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
