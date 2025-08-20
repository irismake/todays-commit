import SwiftUI

struct KakaoMapButton: View {
  var body: some View {
    VStack {
      Text("여기는 컨테이너 내부")
        .font(.headline)
        .foregroundColor(.white)
    }
    .frame(maxWidth: .infinity)
    .frame(height: 200)
    .background(Color.gray.opacity(0.2))
    .cornerRadius(16)
  }
}

struct KakaoMapButton_Previews: PreviewProvider {
  static var previews: some View {
    KakaoMapButton()
  }
}
