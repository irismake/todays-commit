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
    }
  }
}
