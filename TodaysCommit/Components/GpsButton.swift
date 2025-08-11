import SwiftUI
 
struct GpsButton: View {
  @EnvironmentObject var mapManager: MapManager
  let buttonSize = GlobalStore.shared.screenWidth / 8
    
  var body: some View {
    Button(action: {
      print("현재 위치로 이동")
      mapManager.updateCell(newCoord: mapManager.myCoord)
    }) {
      Image("gps")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: buttonSize)
    }
  }
}
