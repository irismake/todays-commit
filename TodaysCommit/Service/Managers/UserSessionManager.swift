import Foundation

enum UserSessionManager {
  static func saveUserSession(_ userData: UserResponse) {
    accessToken = userData.accessToken
    isGuest = false
    print("✅ access token 저장 완료")
  }
    
  static func updateAccessToken(_ token: String) {
    accessToken = token
    print("✅ access token 업데이트 완료")
  }
  
  static func loginAsGuest() {
    isGuest = true
    print("👤 게스트 모드 진입")
  }

  static func clearStorgeData() {
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: "access_token")
    defaults.set(false, forKey: "is_guest")
    print("🚪 로그아웃 완료")
  }

  static var isGuest: Bool {
    get { UserDefaults.standard.bool(forKey: "is_guest") }
    set { UserDefaults.standard.set(newValue, forKey: "is_guest") }
  }

  static var hasAccessToken: Bool {
    UserDefaults.standard.string(forKey: "access_token") != nil
  }
    
  static var accessToken: String? {
    get { UserDefaults.standard.string(forKey: "access_token") }
    set {
      if let v = newValue, !v.isEmpty {
        UserDefaults.standard.set(v, forKey: "access_token")
      } else {
        UserDefaults.standard.removeObject(forKey: "access_token")
      }
    }
  }
}
