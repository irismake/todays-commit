import AuthenticationServices
import AuthenticationServices

final class AppleSignInDelegate: NSObject, ASAuthorizationControllerDelegate {
  let completion: (Result<UserResponse, AppleLoginError>) -> Void

  init(completion: @escaping (Result<UserResponse, AppleLoginError>) -> Void) {
    self.completion = completion
  }

  func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
      completion(.failure(.invalidCredential))
      return
    }

    guard let codeData = appleIDCredential.authorizationCode,
          let authorizationCode = String(data: codeData, encoding: .utf8)
    else {
      completion(.failure(.tokenMissing))
      return
    }

    let fullName = appleIDCredential.fullName

    let userName: String? = {
      guard let fullName else {
        return nil
      }
      let first = fullName.givenName ?? ""
      let last = fullName.familyName ?? ""
      let name = "\(last)\(first)".trimmingCharacters(in: .whitespaces)
      return name.isEmpty ? nil : name
    }()

    UserAPI.loginWithApple(authorizationCode: authorizationCode, userName: userName, completion: completion)
  }

  func authorizationController(controller _: ASAuthorizationController, didCompleteWithError error: Error) {
    let nsError = error as NSError

    if nsError.code == ASAuthorizationError.canceled.rawValue {
      completion(.failure(.canceled))
    } else if nsError.domain == NSURLErrorDomain {
      completion(.failure(.networkError(error)))
    } else {
      completion(.failure(.unknown(error)))
    }
  }
}
