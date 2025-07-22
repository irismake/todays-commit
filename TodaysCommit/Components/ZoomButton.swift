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
  @EnvironmentObject var viewModel: CommitViewModel
    
  var body: some View {
    let zoomOutDisable = (viewModel.mapLevel == 2)
    let zoomInDisable = (viewModel.mapLevel == 0 || mapData[viewModel.mapZoneCode] == nil)
    let actionDisable = isZoomIn ? zoomInDisable : zoomOutDisable
      
    Button(action: {
      if isZoomIn {
        guard let code = viewModel.selectedZoneCode else {
          return
        }
        viewModel.mapZoneCode = code
        viewModel.mapLevel -= 1
      } else {
        let code = viewModel.mapZoneCode
        guard let upperCode = getUpperZoneCode(from: code) else {
          return
        }
        viewModel.mapZoneCode = upperCode
        viewModel.mapLevel += 1
      }
      viewModel.resetToDefault()

    }) {
      Image(systemName:
        isZoomIn ? "plus" : "minus")
        .font(.system(size: 10, weight: .bold))
        .frame(width: 20, height: 20)
        .background(
          actionDisable ? Color(.systemGray) : Color(.systemBlue)
        )
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
    }
    .disabled(actionDisable)
  }
}
