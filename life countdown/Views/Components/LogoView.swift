import SwiftUI

struct LogoView: View {
    var scale: CGFloat = 1.0  // 默认为原始大小（100%）
    
    var body: some View {
        HStack(spacing: 12 * scale) {  // 间距也按比例缩放
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 50 * scale, height: 20 * scale)
            
            Text("Life Countdown")
                .font(.system(size: 16 * scale, weight: .ultraLight))
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
