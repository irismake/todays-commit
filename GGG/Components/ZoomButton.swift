import SwiftUI

func getUpperZoneCode(from code: Int) -> Int? {
  let codeStr = String(code)
  if codeStr.suffix(5) != "00000" {
    // 동 -> 구
    let upperCodeStr = String(codeStr.prefix(5)) + "00000"
    return Int(upperCodeStr)
  } else if codeStr.suffix(8) != "00000000" {
    // 구 -> 시
    let upperCodeStr = String(codeStr.prefix(2)) + "00000000"
    return Int(upperCodeStr)
  } else if codeStr.count != 3 {
    // 시 -> 나라
    return 410
  } else {
    return nil
  }
}

struct ZoomButton: View {
  var isZoomIn: Bool
  @EnvironmentObject var viewModel: CommitViewModel
    
  var body: some View {
    let zoomOutDisable = (viewModel.currentZoneLevel == 2)
    let zoomInDisable = (viewModel.currentZoneLevel == 0 || mapData[viewModel.currentZoneCode] == nil)
    let actionDisable = isZoomIn ? zoomInDisable : zoomOutDisable
      
    Button(action: {
      if isZoomIn {
        if let code = viewModel.selectedZoneCode {
          viewModel.currentZoneCode = code
          viewModel.currentZoneLevel -= 1
          viewModel.selectedZoneCode = nil
        }
      } else {
        let code = viewModel.currentZoneCode
        if let upperCode = getUpperZoneCode(from: code) {
          print(upperCode)
          viewModel.currentZoneCode = upperCode
          viewModel.currentZoneLevel += 1
          viewModel.selectedZoneCode = code
        }
      }
      print(viewModel.currentZoneLevel)
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
