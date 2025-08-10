import SwiftUI

struct ToastView: View {
  let message: String
    
  var body: some View {
    Text(message)
      .foregroundColor(.white)
      .padding(.horizontal, 16)
      .padding(.vertical, 10)
      .background(Color.black.opacity(0.7))
      .cornerRadius(10)
      .transition(.opacity.combined(with: .move(edge: .top)))
  }
}
