import SwiftUI

struct ZoomButton: View {
  var zoomAction: () -> Void
  var iconName: String
    
  var body: some View {
    Button(action: zoomAction) {
      Image(systemName: iconName)
        .font(.system(size: 10, weight: .bold))
        .frame(width: 20, height: 20)
        .background(Color(.systemBlue))
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
    }
  }
}
