
import SwiftUI

struct LoginView: View {
  var body: some View {
    VStack(spacing: 20) {
      KakaoLoginButton()
      AppleLoginButton()
    }.padding()
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
