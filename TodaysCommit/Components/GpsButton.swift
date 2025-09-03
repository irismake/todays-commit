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
        .aspectRatio(contentMode: .fit)
        .frame(width: 24, height: 24)
        .padding(4)
        .background(
          RoundedRectangle(cornerRadius: 600, style: .continuous)
            .stroke(.secondary, lineWidth: 0.5)
        )
    }
    .buttonStyle(.plain)
  }
}
