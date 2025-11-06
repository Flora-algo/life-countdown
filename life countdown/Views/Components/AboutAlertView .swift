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
            
            // 弹窗宽度：增加40个点
            let popupWidth = gridWidth 
            
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
                VStack(alignment: .leading, spacing: 0) {
                    // 主要文字内容（靠上）
                    Text("人生倒计时 \n每个月留下一个痕迹，亮起一个点。\n没有暂停，没有重来。\n但依旧还有未来。")
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 0x7A/255.0, green: 0x89/255.0, blue: 0x99/255.0))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4)
                        .padding(.top, 15)
                        .padding(.horizontal, 23)
                    
                    Spacer()
                    
                    // 底部：版本号和版权信息
                    VStack(alignment: .trailing, spacing: 2) {
                        // 版本号
                        Text("v1.0.1")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 0x5A/255.0, green: 0x69/255.0, blue: 0x79/255.0))
                        
                        // 版权信息（可点击）
                        Text("© 2025 algormula Pte. Ltd. All rights reserved.")
                            .font(.system(size: 12))
                            .foregroundColor(Color(red: 0x5A/255.0, green: 0x69/255.0, blue: 0x79/255.0))
                            .underline()
                            .onTapGesture {
                                // 跳转到技术支持页面
                                if let url = URL(string: "https://cliff-catcher-fb0.notion.site/Life-Countdown-Technical-Support-2a3fd13fdc6f80ab96b9ec3a7c798627?source=copy_link") {
                                    UIApplication.shared.open(url)
                                }
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 15)
                    .padding(.bottom, 15)
                }
                .frame(width: popupWidth, height: 160)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0x16/255.0, green: 0x1E/255.0, blue: 0x2B/255.0, opacity: 0.94))
                )
                .position(
                    x: geometry.size.width / 2,
                    y: CGFloat(topPadding + 30 + 70 + 5)
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
        .background(Color(red: 0.09, green: 0.13, blue: 0.20))
}
