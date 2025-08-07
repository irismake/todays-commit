import CoreLocation
import KakaoSDKAuth
import SwiftUI

struct RootView: View {
  @AppStorage("access_token") var accessToken: String?
  @AppStorage("is_guest") var isGuest: Bool = false
  @State private var isLoading = false
  @StateObject private var locationManager = LocationManager()

  var body: some View {
    if accessToken != nil || isGuest {
      ZStack {
        ContentView()
        overlayView(for: locationManager.authorizationStatus ?? .notDetermined)

        if isLoading {
          Color.black.opacity(0.3).ignoresSafeArea()
          LoadingView()
        }
      }
      .task {
        guard let coord = locationManager.currentLocation else {
          return
        }
        isLoading = true
        defer { isLoading = false }
        await loadInitialData(coord)
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

  func loadInitialData(_ currentLocation: Location) async {
    do {
      let pnuResponse = try await LocationAPI.getPnu(lat: currentLocation.lat, lon: currentLocation.lon)
      let cellDataResponse = try await MapAPI.getCell(pnuResponse.pnu)
      let mapIds = cellDataResponse.maps.map(\.mapId)

      for mapId in mapIds {
        do {
          let mapData = try await MapAPI.getMap(mapId)
          print("✅ mapId \(mapId)의 데이터: \(mapData)")
        } catch {
          print("❌ mapId \(mapId) 에서 에러: \(error)")
        }
      }
    } catch {
      print("❌ 초기 데이터 로드 실패: \(error.localizedDescription)")
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
