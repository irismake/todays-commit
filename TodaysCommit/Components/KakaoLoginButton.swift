import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

import SwiftUI

struct KakaoLoginButton: View {
  var body: some View {
    Button(action: {
      AuthService.shared.kakaoAuth { result in
        switch result {
        case let .success(user):
          UserSessionManager.saveUserSession(user)
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
                
        Text("카카오 로그인")
          .font(.subheadline)
          .foregroundColor(Color.black.opacity(0.85))
          .fontWeight(.medium)
      }
      .frame(height: UIScreen.main.bounds.height * 0.06)
      .frame(maxWidth: .infinity)
      .background(Color(hex: "#FEE500"))
      .cornerRadius(12)
    }
  }
}

struct KakaoLoginButton_Previews: PreviewProvider {
  static var previews: some View {
    KakaoLoginButton()
  }
}
