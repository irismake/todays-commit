import CoreLocation
import SwiftUI

struct RootView: View {
  @AppStorage("access_token") var accessToken: String?
  @AppStorage("is_guest") var isGuest: Bool = false
  @State private var isInitializing = true
  @EnvironmentObject var mapManager: MapManager
  @EnvironmentObject var locationManager: LocationManager
  @State private var showLocPermissionAlert: Bool = false

  var body: some View {
    if accessToken != nil || isGuest {
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
        MainView()
          .onAppear {
            handleLocationStatus(status: locationManager.authorizationStatus ?? .notDetermined)
          }
          .onChange(of: locationManager.authorizationStatus ?? .notDetermined) { _, newStatus in
            handleLocationStatus(status: newStatus)
          }
          .overlay(overlayView())
      }
    } else {
      LoginView()
    }
  }

  private func handleLocationStatus(status: CLAuthorizationStatus) {
    if status == .denied || status == .restricted {
      showLocPermissionAlert = true
    } else if status == .authorizedAlways || status == .authorizedWhenInUse {
      showLocPermissionAlert = false
      Task {
        guard let currentLocation = locationManager.currentLocation else {
          return
        }
        await fetchInitMapData(currentLocation)
      }
    }
  }
    
  func fetchInitMapData(_ currentLocation: LocationBase) async {
    do {
      let locationResponse = try await LocationAPI.getPnu(lat: currentLocation.lat, lon: currentLocation.lon)
      let cells = try await MapAPI.getCell(locationResponse.pnu)

      mapManager.gpsCells = []
      for cell in cells {
        let mapId = cell.mapId
        let mapLevel = cell.mapLevel
        mapManager.gpsCells.append(cell)
        
        if mapLevel == 1 {
          await mapManager.fetchMapData(of: mapId)
        }
      }
    } catch {
      print("❌ 초기 데이터 로드 실패: \(error.localizedDescription)")
    }
  }

  @ViewBuilder
  private func overlayView() -> some View {
    AlertDialog(
      title: "위치 권한 필요",
      message: "현재 위치를 가져올 수 없습니다. 설정에서 위치 권한을 허용해주세요.",
      isPresented: $showLocPermissionAlert
    ) {
      Button("설정열기") {
        if let url = URL(string: UIApplication.openSettingsURLString) {
          UIApplication.shared.open(url)
        }
      }
    }
  }
}
