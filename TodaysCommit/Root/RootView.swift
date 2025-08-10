import CoreLocation
import KakaoSDKAuth
import SwiftUI

struct RootView: View {
  @AppStorage("access_token") var accessToken: String?
  @AppStorage("is_guest") var isGuest: Bool = false
  @State private var isInitializing = true
  @EnvironmentObject var mapManager: MapManager
  @EnvironmentObject var locationManager: LocationManager

  var body: some View {
    if accessToken != nil || isGuest {
      Group {
        if isInitializing {
          SplashView()
            .task {
              guard let coord = locationManager.currentLocation else {
                return
              }
              await mapManager.fetchInitMapData(coord)
              isInitializing = false
            }
        } else {
          ZStack {
            ContentView()
            overlayView(for: locationManager.authorizationStatus ?? .notDetermined)
          }
        }
      }
    } else {
      LoginView()
        .onOpenURL { url in
          if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
          }
        }
    }
  }

  @ViewBuilder
  func overlayView(for status: CLAuthorizationStatus?) -> some View {
    switch status {
    case .some(.notDetermined):
      EmptyView()
    case .some(.denied), .some(.restricted):
      LocationPermissionOverlay()
    case .some(.authorizedWhenInUse), .some(.authorizedAlways):
      EmptyView()
    case .none:
      Text("권한 상태를 알 수 없습니다.")
    @unknown default:
      Text("예상치 못한 권한 상태입니다.")
    }
  }
}
