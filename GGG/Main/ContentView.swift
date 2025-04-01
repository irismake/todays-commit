//
//  ContentView.swift
//  GGG
//
//  Created by 김가희 on 3/10/25.
//

import SwiftUI

struct ContentView: View {
  @StateObject var viewModel = CommitViewModel()
  var body: some View {
    TabView {
      GitGrassView()
        .tabItem {
          Image(systemName: "square.grid.3x3.fill")
            .font(.system(size: 24))
          Text("GitGrass")
            .font(.caption)
        }
        .environmentObject(viewModel)
      SettingsView()
        .tabItem {
          Image(systemName: "gearshape.fill")
            .font(.system(size: 24))
          Text("Settings")
            .font(.caption)
        }
    }
  }
}

#Preview {
  ContentView()
}
