import Foundation

enum UserSessionManager {
  static func save(user: UserResponse) {
    let defaults = UserDefaults.standard
    defaults.set(user.accessToken, forKey: "access_token")
    print("✅ access token 저장 완료")
  }

  static func clear() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "access_token")
  }
}
