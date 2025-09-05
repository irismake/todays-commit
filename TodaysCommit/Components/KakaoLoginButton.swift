import SwiftUI

struct KakaoLoginButton: View {
  @Environment(\.dismiss) private var dismiss
  @State private var tempUserData: UserResponse? = nil

  var body: some View {
    Button(action: {
      AuthService.shared.kakaoAuth { result in
        switch result {
        case let .success(user):
          if user.isFirstLogin {
            tempUserData = user
          } else {
            UserSessionManager.saveUserSession(user)
            dismiss()
          }
        case let .failure(error):
          print("❌ 로그인 실패: \(error.localizedDescription)")
        }
      }
    }) {
      HStack {
        Image("kakao_symbol")
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .frame(height: 18)
          .foregroundColor(.black)
                
        Text("Login with Kakao")
          .font(.subheadline)
          .fontWeight(.medium)
          .foregroundColor(Color.black.opacity(0.85))
      }
      .frame(height: UIScreen.main.bounds.height * 0.06)
      .frame(maxWidth: .infinity)
      .background(Color(hex: "#FEE500"))
      .cornerRadius(12)
    }
    .sheet(item: $tempUserData) { user in
      TermsOfUseSheet {
        UserSessionManager.saveUserSession(user)
        dismiss()
      }
    }
  }
}

struct KakaoLoginButton_Previews: PreviewProvider {
  static var previews: some View {
    KakaoLoginButton()
  }
}
