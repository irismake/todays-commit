import SwiftUI

struct LocationPermissionOverlay: View {
  var body: some View {
    Color.clear
      .alert("위치 권한 필요", isPresented: .constant(true)) {
        Button("설정 열기") {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
          }
        }
      } message: {
        Text("현재 위치를 가져올 수 없습니다. 설정에서 위치 권한을 허용해주세요.")
      }
  }
}
