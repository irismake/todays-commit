import SwiftUI
 
struct GpsButton: View {
  @EnvironmentObject var mapManager: MapManager
  let buttonSize = GlobalStore.shared.screenWidth / 8
    
  var body: some View {
    Button {
      Task {
        await mapManager.updateCell(newCoordId: mapManager.gpsCoordId, grassColor: .black)
      }
    } label: {
      Image("gps")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: buttonSize)
    }
  }
}
