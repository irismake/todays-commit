import KakaoSDKAuth
import SwiftUI

struct LoginView: View {
  var isSheet: Bool = false
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack(spacing: 12) {
      if isSheet {
        HStack {
          Spacer()
          Button(action: { dismiss() }) {
            Image(systemName: "xmark")
              .font(.system(size: 16, weight: .medium))
              .foregroundColor(.primary)
              .padding(12)
          }
        }
      }

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

      if !isSheet {
        Button(action: {
          UserSessionManager.loginAsGuest()
        }) {
          Text("로그인 없이 둘러보기")
            .font(.subheadline)
            .fontWeight(.medium)
            .foregroundColor(Color.primary)
            .padding()
        }
      } else {
        Text("로그인하고 오늘의 커밋을 시작해보세요!")
          .font(.subheadline)
          .fontWeight(.light)
          .foregroundColor(Color.primary)
          .padding()
      }
    }
    .padding()
    .onOpenURL { url in
      if AuthApi.isKakaoTalkLoginUrl(url) {
        _ = AuthController.handleOpenUrl(url: url)
      }
    }
  }
}

struct LoginView_Previews: PreviewProvider {
  static var previews: some View {
    LoginView()
  }
}
