import SwiftUI
 
struct GpsButton: View {
  @EnvironmentObject var mapManager: MapManager
  let buttonSize = GlobalStore.shared.screenWidth / 8
    
  var body: some View {
    Button(action: {
      mapManager.updateCell(newCoord: mapManager.myCoord)
        
    }) {
      Image("gps")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: buttonSize)
    }
  }
}
