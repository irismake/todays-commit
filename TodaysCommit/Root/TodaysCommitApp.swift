import KakaoMapsSDK
import KakaoSDKAuth
import KakaoSDKCommon
import SwiftUI

@main
struct TodaysCommitApp: App {
  @StateObject private var locationManager = LocationManager()
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
//      LoginView()
//        .onOpenURL { url in
//          if AuthApi.isKakaoTalkLoginUrl(url) {
//            _ = AuthController.handleOpenUrl(url: url)
//          }
//        }
      ContentView()
        .environmentObject(locationManager)
    }
  }

  class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
      _: UIApplication,
      didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
        SDKInitializer.InitSDK(appKey: kakaoAppKey)
        KakaoSDK.initSDK(appKey: kakaoAppKey)
      } else {
        assertionFailure("❌ KAKAO_APP_KEY is missing in Info.plist")
        return false
      }
      return true
    }
  }
}
