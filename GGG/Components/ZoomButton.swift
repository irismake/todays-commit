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
        if let code = viewModel.selectedZoneCode {
          viewModel.mapZoneCode = code
          viewModel.mapLevel -= 1
          viewModel.selectedZoneCode = nil
        }
      } else {
        let code = viewModel.mapZoneCode
        if let upperCode = getUpperZoneCode(from: code) {
          print(upperCode)
          viewModel.mapZoneCode = upperCode
          viewModel.mapLevel += 1
          viewModel.selectedZoneCode = code
        }
      }
      print(viewModel.mapLevel)
      print(actionDisable)
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
