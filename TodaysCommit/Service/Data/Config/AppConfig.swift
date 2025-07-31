import SwiftUI

enum AppConfig {
  static let kakaoAppKey: String = {
    if let value = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
      return value
    } else {
      assertionFailure("❌ KAKAO_APP_KEY is missing in Info.plist")
      return ""
    }
  }()

  static let baseURL: String = {
    if let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String {
      return url
    } else {
      assertionFailure("❌ BASE_URL is missing in Info.plist")
      return ""
    }
  }()
}
