import SwiftUI

struct MainView: View {
  @EnvironmentObject var mapManager: MapManager
  @EnvironmentObject var placeManager: PlaceManager
  @EnvironmentObject var locationManager: LocationManager
  var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 10) {
        Image("center")
          .resizable()
          .scaledToFit()
          .frame(width: 20, height: 20)

        Text("장위동 34-5")
          .font(.subheadline)
          .foregroundColor(.primary)
          .fontWeight(.semibold)
          
        Image(systemName: "chevron.right")
          .imageScale(.small)
          .foregroundColor(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
        
      ScrollView {
        VStack {
          CommitBanner()
          Picker("범위", selection: $placeManager.placeScope) {
            Text("전체").tag(PlaceScope.main)
            Text("나의 지도").tag(PlaceScope.my)
          }
          .pickerStyle(.segmented)

          HStack(spacing: 12) {
            ZoomButton(zoomingIn: false)
            Text(mapManager.mapName)
              .font(.headline)
              .fontWeight(.semibold)
              .foregroundColor(.primary)
                            
            ZoomButton(zoomingIn: true)
          }
          .padding(.top)
            
          GrassMapView(showMyMap: placeManager.placeScope == .my)

          PlaceView()
        }
            
        .padding()
      }
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}
 