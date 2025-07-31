import AuthenticationServices
import SwiftUI

struct AppleLoginButton: View {
  var body: some View {
    Button(action: {
      AuthService.shared.appleAuth { result in
        switch result {
        case let .success(user):
          UserSessionManager.save(user: user)
        case let .failure(error):
          print("❌ 로그인 실패: \(error.localizedDescription)")
        }
      }
    }) {
      HStack {
        Image("apple_symbol")
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .frame(height: 18)
          .foregroundColor(.white)
            
        Text("Sign in with Apple")
          .font(.subheadline)
          .foregroundColor(Color.white)
          .fontWeight(.medium)
      }
      .frame(height: UIScreen.main.bounds.height * 0.06)
      .frame(maxWidth: .infinity)
      .background(Color.black)
      .cornerRadius(12)
    }
  }
}

struct AppleLoginButton_Previews: PreviewProvider {
  static var previews: some View {
    AppleLoginButton()
  }
}
