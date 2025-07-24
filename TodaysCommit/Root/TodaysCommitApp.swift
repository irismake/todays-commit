import KakaoMapsSDK
import SwiftUI

@main
struct TodaysCommitApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
    
  class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
      _: UIApplication,
      didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
      if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
        SDKInitializer.InitSDK(appKey: kakaoAppKey)
      } else {
        assertionFailure("❌ KAKAO_APP_KEY is missing in Info.plist")
        return false
      }
      return true
    }
  }
}
