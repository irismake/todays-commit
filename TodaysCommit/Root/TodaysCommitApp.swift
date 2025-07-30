import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

@main
struct TodaysCommitApp: App {
  init() {
    if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
      KakaoSDK.initSDK(appKey: kakaoAppKey)
    } else {
      assertionFailure("❌ KAKAO_APP_KEY is missing in Info.plist")
    }
  }
    
  var body: some Scene {
    WindowGroup {
      LoginView()
        .onOpenURL { url in
          if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
          }
        }
    }
  }
}
