import Foundation
import KakaoSDKUser

final class AuthService {
  static let shared = AuthService()
  private init() {}

  func kakaoAuth(completion: @escaping (Result<UserResponse, KakaoLoginError>) -> Void) {
    if UserApi.isKakaoTalkLoginAvailable() {
      UserApi.shared.loginWithKakaoTalk { oauthToken, error in
        if let error {
          return completion(.failure(.networkError(error)))
        }

        guard let token = oauthToken?.accessToken else {
          return completion(.failure(.tokenMissing))
        }

        UserAPI.loginWithKakao(token, completion: completion)
      }
    } else {
      UserApi.shared.loginWithKakaoAccount { oauthToken, error in
        if let error {
          return completion(.failure(.networkError(error)))
        }

        guard let token = oauthToken?.accessToken else {
          return completion(.failure(.tokenMissing))
        }

        UserAPI.loginWithKakao(token, completion: completion)
      }
    }
  }
}
