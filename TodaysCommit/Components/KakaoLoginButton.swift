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
    
  func handleKakaoLogin() {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { oauthToken, error in
        if let error {
          print(error)
        } else {
          print("✅ 로그인 성공")
                    
          if let token = oauthToken?.accessToken {
            print("🔑 accessToken: \(token)")
            sendAccessTokenToBackend(token)
          } else {
            print("❌ accessToken이 없음")
          }
        }
      }
    }
  }

  func sendAccessTokenToBackend(_ token: String) {
    guard let url = URL(string: "https://ab7050dedcce.ngrok-free.app/user/login/kakao?access_token=\(token)") else {
      print("❌ URL 생성 실패")
      return
    }
        
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error {
        print("❌ 서버 요청 실패: \(error)")
        return
      }
            
      guard let data else {
        print("❌ 데이터 없음")
        return
      }
            
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let userResponse = try decoder.decode(UserResponse.self, from: data)

        print("✅ 파싱 성공: \(userResponse)")
        storeUserSession(userResponse)

      } catch {
        print("❌ 응답 디코딩 실패: \(error)")
        print("📦 응답 원문: \(String(data: data, encoding: .utf8) ?? "해석 불가")")
      }
    }
        
    task.resume()
  }
    
  func storeUserSession(_ response: UserResponse) {
    let defaults = UserDefaults.standard
    defaults.set(response.accessToken, forKey: "access_token")
    defaults.set(response.userName, forKey: "user_name")
  
    print("✅ 사용자 정보 저장 완료")
  }
}

struct KakaoLoginButton_Previews: PreviewProvider {
  static var previews: some View {
    KakaoLoginButton()
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
