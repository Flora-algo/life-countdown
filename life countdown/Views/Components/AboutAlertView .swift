import SwiftUI

struct AboutAlertView: View {
    @Binding var isPresented: Bool
    @ObservedObject var languageManager = LanguageManager.shared

    @State private var feedbackText: String = ""
    @State private var showThankYou: Bool = false

    let dotsPerRow = 24
    
    // ✨ 新增：设备检测
    private var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    // ✨ 新增：缩放倍数（和 LifeGridView 保持一致）
    private var scaleFactor: CGFloat {
        isIPad ? 1.8 : 1.0
    }

    // 字数统计
    private var wordCount: Int {
        let words = feedbackText.split(separator: " ")
        return words.count
    }

    // 弹窗高度
    private var popupHeight: CGFloat {
        showThankYou ? 240 * scaleFactor : 430 * scaleFactor
    }

    // 计算弹窗 Y 位置
    private func popupPositionY(topPadding: Int) -> CGFloat {
        let baseY = topPadding + 30 + 70 + 5
        let offset = showThankYou ? 40 : 135
        return CGFloat(baseY + offset) * scaleFactor
    }

    var body: some View {
        GeometryReader { geometry in
            let dotSize: CGFloat = 5 * scaleFactor  // ← 和 LifeGridView 一样
            let availableWidth = min(geometry.size.width * 0.85, 450)
            let calculatedSpacing = (availableWidth - CGFloat(dotsPerRow) * dotSize) / CGFloat(dotsPerRow - 1)
            let spacing = max(calculatedSpacing, 9 * scaleFactor)  // ← 和 LifeGridView 一样
            let gridWidth = CGFloat(dotsPerRow) * dotSize + CGFloat(dotsPerRow - 1) * spacing
            
            // 弹窗宽度：和点阵一样宽
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
                    Text("about_message".localized())
                        .font(.system(size: 15 * scaleFactor))  // ← 字体缩放
                        .foregroundColor(Color(red: 0x7A/255.0, green: 0x89/255.0, blue: 0x99/255.0))
                        .multilineTextAlignment(.leading)
                        .lineSpacing(4 * scaleFactor)  // ← 行间距缩放
                        .padding(.top, 25 * scaleFactor)  // ← 增加顶部间距，让内容更居中
                        .padding(.horizontal, 23 * scaleFactor)  // ← padding 缩放
                    
                    Spacer()
                    
                    // 底部：版本号和版权信息
                    VStack(alignment: .trailing, spacing: 2 * scaleFactor) {  // ← spacing 缩放
                        // 版本号
                        Text("v1.0.1")
                            .font(.system(size: 12 * scaleFactor))  // ← 字体缩放
                            .foregroundColor(Color(red: 0x5A/255.0, green: 0x69/255.0, blue: 0x79/255.0))
                        
                        // 版权信息（可点击）
                        Text("copyright".localized())
                            .font(.system(size: 12 * scaleFactor))  // ← 字体缩放
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
                    .padding(.trailing, 15 * scaleFactor)
                    .padding(.bottom, 15 * scaleFactor)

                    // 感谢消息（当 showThankYou 为 true 时显示）
                    if showThankYou {
                        Text("feedback_thanks".localized())
                            .font(.system(size: 15 * scaleFactor))
                            .foregroundColor(Color(red: 0x7A/255.0, green: 0x89/255.0, blue: 0x99/255.0))
                            .padding(.horizontal, 23 * scaleFactor)
                            .padding(.top, 10 * scaleFactor)
                            .padding(.bottom, 15 * scaleFactor)
                    }

                    // 反馈输入框
                    if !showThankYou {
                        // 文字输入框
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $feedbackText)
                                .font(.system(size: 13 * scaleFactor))
                                .foregroundColor(Color(red: 0x7A/255.0, green: 0x89/255.0, blue: 0x99/255.0))
                                .scrollContentBackground(.hidden)
                                .background(Color(red: 0x0E/255.0, green: 0x16/255.0, blue: 0x22/255.0))
                                .cornerRadius(10 * scaleFactor)
                                .lineSpacing(18 * scaleFactor)
                                .accentColor(Color(red: 55/255.0, green: 85/255.0, blue: 110/255.0))
                                .padding(.horizontal, 23 * scaleFactor)
                                .frame(height: 221 * scaleFactor)
                                .onChange(of: feedbackText) { newValue in
                                    // 限制100个单词
                                    if wordCount > 100 {
                                        let words = newValue.split(separator: " ")
                                        feedbackText = words.prefix(100).joined(separator: " ")
                                    }
                                }

                            // Placeholder
                            if feedbackText.isEmpty {
                                Text("feedback_placeholder".localized())
                                    .font(.system(size: 13 * scaleFactor))
                                    .foregroundColor(Color(red: 0x5A/255.0, green: 0x69/255.0, blue: 0x79/255.0))
                                    .padding(.horizontal, 28 * scaleFactor)
                                    .padding(.vertical, 8 * scaleFactor)
                                    .allowsHitTesting(false)
                            }

                            // 字数统计（输入框内部右下角）
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    Text("\(wordCount)/100")
                                        .font(.system(size: 11 * scaleFactor))
                                        .foregroundColor(Color(red: 0x5A/255.0, green: 0x69/255.0, blue: 0x79/255.0))
                                        .padding(.trailing, 28 * scaleFactor)
                                        .padding(.bottom, 8 * scaleFactor)
                                }
                            }
                        }

                        // 底部：反馈标签和发送按钮
                        HStack {
                            Text("feedback_label".localized())
                                .font(.system(size: 13 * scaleFactor))
                                .foregroundColor(Color(red: 0x5A/255.0, green: 0x69/255.0, blue: 0x79/255.0))

                            Spacer()

                            // 发送按钮（使用 NavigationButton 样式的前进图标）
                            Button(action: {
                                sendFeedback()
                            }) {
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16 * scaleFactor, weight: .regular))
                                    .foregroundColor(Color(red: 50/255, green: 65/255, blue: 80/255))
                                    .frame(width: 24 * scaleFactor, height: 24 * scaleFactor)
                            }
                            .disabled(feedbackText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        }
                        .padding(.horizontal, 23 * scaleFactor)
                        .padding(.top, 4 * scaleFactor)
                        .padding(.bottom, 20 * scaleFactor)
                    }
                }
                .frame(width: popupWidth, height: popupHeight)
                .background(
                    RoundedRectangle(cornerRadius: 8 * scaleFactor)
                        .fill(Color(red: 0x16/255.0, green: 0x1E/255.0, blue: 0x2B/255.0, opacity: 0.94))
                )
                .position(
                    x: geometry.size.width / 2,
                    y: popupPositionY(topPadding: topPadding)
                )
                .onTapGesture {
                    // 防止点击弹窗本身关闭
                }
            }
        }
    }

    // 发送反馈
    private func sendFeedback() {
        // TODO: 实现发送邮件到 algormula@gmail.com
        // 目前先显示感谢消息
        withAnimation {
            showThankYou = true
        }

        // 8秒后重置
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            withAnimation {
                showThankYou = false
                feedbackText = ""
            }
        }
    }
}

#Preview {
    AboutAlertView(isPresented: .constant(true))
        .background(Color(red: 0.09, green: 0.13, blue: 0.20))
}
