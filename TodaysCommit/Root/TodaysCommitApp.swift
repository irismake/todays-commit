import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

@main
struct TodaysCommitApp: App {
  init() {
    KakaoSDK.initSDK(appKey: AppConfig.kakaoAppKey)
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
