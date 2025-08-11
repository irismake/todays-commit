import SwiftUI

struct ContentView: View {
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
