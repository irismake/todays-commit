import SwiftUI

func getUpperZoneCode(from code: Int) -> Int? {
  let codeStr = String(code)
  if codeStr.suffix(6) != "000000" {
    // 동 → 구 (앞 5자리 + 5개 0)
    let upperCodeStr = String(codeStr.prefix(5)) + "00000"
    return Int(upperCodeStr)
  } else if codeStr.suffix(8) != "00000000" {
    // 구 → 시 (앞 2자리 + 8개 0)
    let upperCodeStr = String(codeStr.prefix(2)) + "00000000"
    return Int(upperCodeStr)
  } else {
    // 이미 시
    return nil
  }
}

struct ZoomButton: View {
  var isZoomIn: Bool

  @EnvironmentObject var viewModel: CommitViewModel
    
  var body: some View {
    Button(action: {
      if isZoomIn {
        if let code = viewModel.selectedZoneCode, mapData[code] != nil {
          viewModel.currentZoneCode = code
        }
      } else {
        let code = viewModel.currentZoneCode
        if let upperCode = getUpperZoneCode(from: code) {
          viewModel.currentZoneCode = upperCode
        }
      }
    }) {
      Image(systemName:
        isZoomIn ? "plus" : "minus")
        .font(.system(size: 10, weight: .bold))
        .frame(width: 20, height: 20)
        .background(Color(.systemBlue))
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
    }
  }
}
