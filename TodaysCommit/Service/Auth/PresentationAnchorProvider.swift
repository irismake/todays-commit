
import AuthenticationServices

final class PresentationAnchorProvider: NSObject, ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap(\.windows)
      .first { $0.isKeyWindow } ?? UIWindow()
  }
}
