import SwiftUI

struct SplashView: View {
    @EnvironmentObject var appState: AppState  // ← 添加这行
    var body: some View {
        ZStack(alignment: .topLeading) {  // ← 以左上角为基准点
            
            // 背景色
            Color(red: 0.09, green: 0.13, blue: 0.20)
                .ignoresSafeArea()
            
            // Logo - 距左59，距上179
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 89, height: 60)
                .offset(x: 59, y: 139)  // ← 精确定位
            
            // App 名称 - 距左59，距上265（179 + Logo高60 + 间距26）
            Text("life countdown")
                .font(.system(size: 32, weight: .thin))
                .foregroundColor(Color(red: 0.44, green: 0.75, blue: 0.75))
                .offset(x: 59, y: 235)  // ← 179 + 60 + 26 = 265
            
            // 前进按钮
            NavigationButton {
                appState.navigateToAgeInput()
            }
            .offset(x: 59, y: 578)
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState())
}
