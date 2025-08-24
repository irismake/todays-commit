import SwiftUI
 
struct GpsButton: View {
  @EnvironmentObject var mapManager: MapManager
    
  var body: some View {
    Button {
      Task {
        await mapManager.updateCell(newCoordId: mapManager.gpsCoordId, grassColor: .primary)
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
