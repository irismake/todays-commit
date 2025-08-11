import SwiftUI

struct ZoomButton: View {
  var zoomingIn: Bool
  @EnvironmentObject var mapManager: MapManager

  var body: some View {
    Button(action: {
      mapManager.changeMapLevel(zoomingIn)

    }) {
      Image(systemName:
        zoomingIn ? "plus" : "minus")
        .font(.system(size: 10, weight: .bold))
        .frame(width: 20, height: 20)
        .background(
          (zoomingIn ? mapManager.zoomInDisabled : mapManager.zoomOutDisabled)
            ? Color(.systemGray)
            : Color(.systemBlue)
        )
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
    }
    .disabled(zoomingIn ? mapManager.zoomInDisabled : mapManager.zoomOutDisabled)
  }
}
