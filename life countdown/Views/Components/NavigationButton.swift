import SwiftUI

struct NavigationButton: View {
    let action: () -> Void  // 点击后执行的动作
    
    var body: some View {
        Button(action: action) {
            Text("››")
                .font(.system(size: 34, weight: .light))
                .foregroundColor(Color(red: 50/255, green: 65/255, blue: 80/255))
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.09, green: 0.13, blue: 0.20)
            .ignoresSafeArea()
        
        NavigationButton {
            print("Button tapped")
        }
    }
}
