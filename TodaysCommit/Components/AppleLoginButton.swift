import SwiftUI

struct AppleLoginButton: View {
  @Environment(\.colorScheme) var colorScheme

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
          .foregroundColor(colorScheme == .dark ? .black : .white)
          .aspectRatio(contentMode: .fit)
          .frame(height: 18)

        Text("Sign in with Apple")
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundColor(colorScheme == .dark ? .black : .white)
      }
      .frame(height: UIScreen.main.bounds.height * 0.06)
      .frame(maxWidth: .infinity)
      .background(colorScheme == .dark ? Color.white : Color.black)
      .cornerRadius(12)
    }
  }
}

struct AppleLoginButton_Previews: PreviewProvider {
  static var previews: some View {
    AppleLoginButton()
  }
}
