import SwiftUI

struct AboutAlertView: View {
    @Binding var isPresented: Bool
    
    let dotsPerRow = 24
    let dotSize: CGFloat = 5
    
    var body: some View {
        GeometryReader { geometry in
            let availableWidth = min(geometry.size.width * 0.85, 450)
            let calculatedSpacing = (availableWidth - CGFloat(dotsPerRow) * dotSize) / CGFloat(dotsPerRow - 1)
            let spacing = max(calculatedSpacing, 9)
            let gridWidth = CGFloat(dotsPerRow) * dotSize + CGFloat(dotsPerRow - 1) * spacing
            
            // 和 MainView 一样的顶部间距计算
            let topPadding = geometry.safeAreaInsets.top > 0 ? 10 : 60
            
            ZStack {
                // 透明背景（可点击关闭）
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                    }
                
                // 弹窗内容
                VStack {
                    // 文字内容
                    Text("人生倒计时。每个月留下一个痕迹，亮起一个点。\n没有暂停，没有重来。但依旧还有未来。")
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 0x7A/255.0, green: 0x89/255.0, blue: 0x99/255.0))
                        .multilineTextAlignment(.trailing)
                        .lineSpacing(2)
                        .frame(width: gridWidth - 30, height: 36)
                }
                .frame(width: gridWidth, height: 46)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0x16/255.0, green: 0x1E/255.0, blue: 0x2B/255.0))
                )
                .position(
                    x: geometry.size.width / 2,
                    y: CGFloat(topPadding + 30 + 10 + 1)  // 顶部padding + Logo栏高度 + spacing + 标题行一半
                )
                .onTapGesture {
                    // 防止点击弹窗本身关闭
                }
            }
        }
    }
}

#Preview {
    AboutAlertView(isPresented: .constant(true))
}
