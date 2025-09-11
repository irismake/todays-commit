import SwiftUI
 
struct GpsButton: View {
  @EnvironmentObject var mapManager: MapManager
    
  var body: some View {
    Button {
      Task {
        if let coordId = mapManager.gpsCoordId {
          await mapManager.updateCell(newCoordId: coordId, grassColor: .primary)
        } else {
          await mapManager.fetchMapData()
        }
      }
    } label: {
      Image("gps")
        .resizable()
        .scaledToFit()
        .frame(height: 30)
    }
    .buttonStyle(.plain)
  }
}
