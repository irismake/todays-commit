import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      NavigationStack {
        MainView()
          .navigationBarHidden(true)
      }
      .tabItem {
        Image(systemName: "square.grid.3x3.fill")
        Text("GitGrass")
      }

      NavigationStack {
        SettingsView()
          .navigationTitle("Settings")
      }
      .tabItem {
        Image(systemName: "gearshape.fill")
        Text("Settings")
      }
    }
    .toolbar(.visible, for: .tabBar)
    .background(Color(.systemBackground))
    .ignoresSafeArea(edges: .bottom)
  }
}
