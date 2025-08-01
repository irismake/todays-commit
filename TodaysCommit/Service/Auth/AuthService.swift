import AuthenticationServices
import Foundation
import KakaoSDKUser

final class AuthService {
  static let shared = AuthService()
  private init() {}
    
  private var appleDelegate: AppleSignInDelegate?
  private var anchorProvider: PresentationAnchorProvider?

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

  func appleAuth(completion: @escaping (Result<UserResponse, AppleLoginError>) -> Void) {
    let request = ASAuthorizationAppleIDProvider().createRequest()
    request.requestedScopes = [.fullName, .email]

    let delegate = AppleSignInDelegate(completion: completion)
    let provider = PresentationAnchorProvider()

    appleDelegate = delegate
    anchorProvider = provider

    let controller = ASAuthorizationController(authorizationRequests: [request])
    controller.delegate = delegate
    controller.presentationContextProvider = provider
    controller.performRequests()
  }
}
