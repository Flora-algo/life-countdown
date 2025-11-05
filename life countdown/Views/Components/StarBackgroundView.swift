import SwiftUI

struct StarBackgroundView: View {
    @State private var stars: [Star] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(stars) { star in
                    Circle()
                        .fill(Color(red: 140/255.0, green: 210/255.0, blue: 200/255.0).opacity(star.opacity))  // ← 更亮的青绿色
                        .frame(width: star.size, height: star.size)
                        .position(x: star.x, y: star.y)
                        .blur(radius: star.blur)
                }
            }
            .onAppear {
                startStarAnimation(in: geometry.size)
            }
        }
    }
    
    func startStarAnimation(in size: CGSize) {
        // 初始生成一些星星
        for _ in 0..<20 {
            addStar(in: size, initialDelay: Double.random(in: 0...3))
        }
        
        // 持续生成新星星
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            addStar(in: size, initialDelay: 0)
        }
    }
    
    func addStar(in size: CGSize, initialDelay: Double) {
        let star = Star(
            x: CGFloat.random(in: 0...size.width),
            y: size.height + 20, // 从底部开始
            size: CGFloat.random(in: 1...2),
            opacity: Double.random(in: 0.3...0.8),
            blur: CGFloat.random(in: 0...1)
        )
        
        stars.append(star)
        
        // 动画：上升 + 淡出
        DispatchQueue.main.asyncAfter(deadline: .now() + initialDelay) {
            if let index = stars.firstIndex(where: { $0.id == star.id }) {
                withAnimation(.linear(duration: Double.random(in: 8...19))) {
                    stars[index].y = -50 // 上升到顶部
                    stars[index].opacity = 0 // 淡出
                }
                
                // 动画结束后删除
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    stars.removeAll { $0.id == star.id }
                }
            }
        }
    }
}

struct Star: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let size: CGFloat
    var opacity: Double
    let blur: CGFloat
}

#Preview {
    ZStack {
        Color(red: 0.09, green: 0.13, blue: 0.20)
            .ignoresSafeArea()
        
        StarBackgroundView()
    }
}
