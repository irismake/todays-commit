import SwiftUI

struct ContentView: View {
  @EnvironmentObject var viewModel: CommitViewModel
  @EnvironmentObject var mapManager: MapManager

  var body: some View {
    ZStack {
      TabView {
        GitGrassView()
          .tabItem {
            Image(systemName: "square.grid.3x3.fill")
            Text("GitGrass")
          }

        SettingsView()
          .tabItem {
            Image(systemName: "gearshape.fill")
            Text("Settings")
          }
      }
    }
  }
}
