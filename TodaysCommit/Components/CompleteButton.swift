import SwiftUI

struct CompleteButton: View {
  var onComplete: () -> Void
  let title: String
  let color: Color

  var body: some View {
    Button(action: {
      onComplete()
    }) {
      Text(title)
        .font(.headline)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .padding()
    }
    .background(color)
    .cornerRadius(12)
  }
}
