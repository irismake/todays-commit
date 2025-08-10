import SwiftUI

func getUpperZoneCode(from code: Int) -> Int? {
  let codeStr = String(code)
  if codeStr.count == 2 {
    return 410
  } else {
    let upperCodeStr = codeStr.dropLast(3)
    return Int(upperCodeStr)
  }
}

struct ZoomButton: View {
  var isZoomIn: Bool
  @EnvironmentObject var mapManager: MapManager

  var zoomOutDisabled: Bool {
    !(0 ... 1).contains(mapManager.mapLevel)
  }

  var zoomInDisabled: Bool {
    !(1 ... 2).contains(mapManager.mapLevel)
  }
    
  var body: some View {
    Button(action: {
      if isZoomIn {
        mapManager.mapLevel -= 1
      } else {
        mapManager.mapLevel += 1
      }

    }) {
      Image(systemName:
        isZoomIn ? "plus" : "minus")
        .font(.system(size: 10, weight: .bold))
        .frame(width: 20, height: 20)
        .background(
          (isZoomIn ? zoomInDisabled : zoomOutDisabled)
            ? Color(.systemGray)
            : Color(.systemBlue)
        )
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
    }
    .disabled(isZoomIn ? zoomInDisabled : zoomOutDisabled)
  }
}
