import CoreLocation
import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = CommitViewModel()
  @StateObject private var locationManager = LocationManager()

  var body: some View {
    ZStack {
      TabView {
        GitGrassView()
          .tabItem {
            Image(systemName: "square.grid.3x3.fill")
            Text("GitGrass")
          }
          .environmentObject(viewModel)

        SettingsView()
          .tabItem {
            Image(systemName: "gearshape.fill")
            Text("Settings")
          }
      }
      overlayView(for: locationManager.authorizationStatus ?? .notDetermined)
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
