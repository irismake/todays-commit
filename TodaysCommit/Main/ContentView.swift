import SwiftUI

struct ContentView: View {
  var body: some View {
    TabView {
      NavigationStack {
        MainView()
      }
      .tabItem {
        NavBarItem(name: "nav_main")
      }

      NavigationStack {
        SettingsView()
          .navigationTitle("Settings")
      }
      .tabItem {
        NavBarItem(name: "nav_user")
      }
    }
    .tint(.primary)
    .toolbar(.visible, for: .tabBar)
    .background(Color(.systemBackground))
    .ignoresSafeArea(edges: .bottom)
  }
}
