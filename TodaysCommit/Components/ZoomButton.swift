import SwiftUI

struct ZoomButton: View {
  var zoomingIn: Bool
  @EnvironmentObject var mapManager: MapManager
    
  var body: some View {
    Button(action: {
      mapManager.changeMapLevel(zoomingIn)
    }) {
      Image(systemName: zoomingIn ? "plus" : "minus")
        .font(.system(size: 10, weight: .bold))
        .frame(width: 18, height: 18)
        .foregroundColor(Color.white)
        .background(
          (zoomingIn ? mapManager.zoomInDisabled : mapManager.zoomOutDisabled)
            ? Color(.systemGray4)
            : Color(.systemBlue)
        )
        .clipShape(Circle())
    }
    .disabled(zoomingIn ? mapManager.zoomInDisabled : mapManager.zoomOutDisabled)
  }
}
