import CoreLocation
import KakaoSDKAuth
import SwiftUI

struct RootView: View {
  @AppStorage("access_token") var accessToken: String?
  @AppStorage("is_guest") var isGuest: Bool = false
  @State private var isLoading = false
  @StateObject private var locationManager = LocationManager()
  @StateObject private var mapManager = MapManager()

  var body: some View {
    if accessToken != nil || isGuest {
      ZStack {
        ContentView()
          .environmentObject(mapManager)
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
      let cells = try await MapAPI.getCell(pnuResponse.pnu)

      for cell in cells {
        do {
          let mapId = cell.mapId
          let mapLevel = cell.mapLevel
          let cellData = cell.cellData
          let mapDataResponse = try await MapAPI.getMap(mapId)
          let mapCode = mapDataResponse.mapCode
          let mapData = mapDataResponse.mapData
          let dict = [mapCode: mapData]
        
          switch mapLevel {
          case 0:
            mapManager.mapDataLevel0 = dict
            mapManager.cellDict[0] = cellData
          case 1:
            mapManager.mapDataLevel1 = dict
            mapManager.cellDict[1] = cellData
          default:
            mapManager.mapDataLevel2 = dict
            mapManager.cellDict[2] = cellData
          }
           
        } catch {
          print("❌ loadInitialData 에서 에러: \(error)")
        }
      }
      mapManager.updateMapData(forLevel: 1)
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
