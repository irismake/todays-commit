
import SwiftUI

struct LoginView: View {
  var body: some View {
    VStack(spacing: 12) {
      Image("logo_name")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.horizontal, 120)
        .padding(.vertical, 80)
     
      Image("logo_icon")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding(.horizontal, 100)
        
      Spacer()
        
      AppleLoginButton()
        
      KakaoLoginButton()
      Button(action: {
        UserSessionManager.loginAsGuest()
      }) {
        Text("로그인 없이 둘러보기")
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundColor(Color.primary)
          .padding()
      }
    }.padding()
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
