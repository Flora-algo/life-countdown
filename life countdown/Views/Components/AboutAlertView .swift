import SwiftUI

struct AboutAlertView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // 透明背景（可点击关闭）
            Rectangle()
                .fill(Color.clear)
                .contentShape(Rectangle())  // ← 关键：让透明区域可点击
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
                    .frame(width: 290, height: 36)
            }
            .frame(width: 352, height: 46)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0x16/255.0, green: 0x1E/255.0, blue: 0x2B/255.0))
            )
            .offset(y: -328)
            .onTapGesture {
                // 防止点击弹窗本身关闭
            }
        }
    }
}

#Preview {
    AboutAlertView(isPresented: .constant(true))
}
