import KakaoMapsSDK
import KakaoSDKCommon
import SwiftUI

@main
struct TodaysCommitApp: App {
  @StateObject private var locationManager: LocationManager
  @StateObject private var mapManager: MapManager
  @StateObject private var placeManager: PlaceManager
  @StateObject private var layoutManager: LayoutManager
  @StateObject private var grassManager: GrassManager
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  init() {
    UserDefaults.standard.set(false, forKey: "is_guest")
      
    let loc = LocationManager()
    let map = MapManager()
    let layout = LayoutManager()
    let grass = GrassManager()
      
    _locationManager = StateObject(wrappedValue: loc)
    _mapManager = StateObject(wrappedValue: map)
    _placeManager = StateObject(wrappedValue: PlaceManager(mapManager: map))
    _layoutManager = StateObject(wrappedValue: layout)
    _grassManager = StateObject(wrappedValue: grass)
  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .environmentObject(locationManager)
        .environmentObject(mapManager)
        .environmentObject(placeManager)
        .environmentObject(layoutManager)
        .environmentObject(grassManager)
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
