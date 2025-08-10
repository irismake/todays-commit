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
              guard let currentLocation = locationManager.currentLocation else {
                return
              }
              await fetchInitMapData(currentLocation)
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

  func fetchInitMapData(_ currentLocation: Location) async {
    do {
      let pnuResponse = try await LocationAPI.getPnu(lat: currentLocation.lat, lon: currentLocation.lon)
      let cells = try await MapAPI.getCell(pnuResponse.pnu)

      for cell in cells {
        let mapId = cell.mapId
        let mapLevel = cell.mapLevel
        let cellData = cell.cellData
          
        switch mapLevel {
        case 0:
          mapManager.cellDict[0] = cellData
        case 1:
          mapManager.cellDict[1] = cellData
          await mapManager.fetchMapData(of: mapId)
        default:
          mapManager.cellDict[2] = cellData
        }
        print("데이터 저장")
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
