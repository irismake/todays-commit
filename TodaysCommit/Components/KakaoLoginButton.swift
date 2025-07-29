import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

import SwiftUI

struct KakaoLoginButton: View {
  var body: some View {
    Button(action: {
      handleKakaoLogin()
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

  private func handleKakaoLogin() {}
}

struct KakaoLoginButton_Previews: PreviewProvider {
  static var previews: some View {
    KakaoLoginButton()
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
