import SwiftUI

struct GitGrassView: View {
  @EnvironmentObject var mapManager: MapManager
  @EnvironmentObject var placeManager: PlaceManager

  var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          CommitBanner(commitState: false)

          Picker("범위", selection: $placeManager.placeScope) {
            Text("전체").tag(PlaceScope.main)
            Text("나의 지도").tag(PlaceScope.my)
          }
          .pickerStyle(.segmented)
          .padding(.vertical, 20)

          HStack(spacing: 12) {
            ZoomButton(zoomingIn: false)
                        
            Text(mapManager.mapName)
              .font(.headline)
              .fontWeight(.semibold)
              .foregroundColor(Color(.black))
       
            ZoomButton(zoomingIn: true)
          }

          ZStack(alignment: .bottomTrailing) {
            GrassMapView(showMyMap: placeManager.placeScope == .my)
            GpsButton()
          }

          PlaceView()
        }
        .padding()
      }
      .navigationTitle("🌱 Git Grass")
      .navigationBarItems(trailing:
        Button(action: {
          print("플러스 버튼 클릭")
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(.blue)
        }
      )
    }
  }
}

struct GitGrassView_Previews: PreviewProvider {
  static var previews: some View {
    GitGrassView()
  }
}
 