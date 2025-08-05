import Foundation

enum UserSessionManager {
  static func saveAccessToken(user: UserResponse) {
    let defaults = UserDefaults.standard
    defaults.set(user.accessToken, forKey: "access_token")
    defaults.set(false, forKey: "is_guest")
    print("✅ access token 저장 완료")
  }
  
  static func loginAsGuest() {
    let defaults = UserDefaults.standard
    defaults.set(true, forKey: "is_guest")
    print("👤 게스트 모드 진입")
  }

  static func cleaStorgeData() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "access_token")
    defaults.set(false, forKey: "is_guest")
    print("🚪 로그아웃 완료")
  }

  static var isGuest: Bool {
    UserDefaults.standard.bool(forKey: "is_guest")
  }

  static var hasAccessToken: Bool {
    UserDefaults.standard.string(forKey: "access_token") != nil
  }

  static var isLoggedIn: Bool {
    hasAccessToken || isGuest
  }
}
