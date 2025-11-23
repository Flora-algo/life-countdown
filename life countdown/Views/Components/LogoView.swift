import SwiftUI

struct LogoView: View {
    var scale: CGFloat = 1.0  // 默认为原始大小（100%）
    
    // ✨ 新增：设备检测
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // ✨ 新增：缩放倍数
    private var scaleFactor: CGFloat {
        isIPad ? 1.8 : 1.0
    }
    
    // ✨ 最终缩放：scale × scaleFactor
    private var finalScale: CGFloat {
        scale * scaleFactor
    }
    
    var body: some View {
        HStack(spacing: 12 * finalScale) {  // ← 使用 finalScale
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 50 * finalScale, height: 20 * finalScale)  // ← 使用 finalScale
            
            Text("Life Countdown")
                .font(.system(size: 16 * finalScale, weight: .ultraLight))  // ← 使用 finalScale
                .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        LogoView()  // 100% 原始大小
        LogoView(scale: 0.74)  // 74% 大小
    }
    .background(Color(red: 0.09, green: 0.13, blue: 0.20))
}
