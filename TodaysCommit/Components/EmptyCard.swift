import SwiftUI

struct EmptyCard: View {
  let title: String
  let subtitle: String
 
  var body: some View {
    VStack(spacing: 12) {
      Text(title)
        .font(.headline)
        .foregroundColor(.secondary)
      Text(subtitle)
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color.lv_0.opacity(0.4))
    .cornerRadius(16)
  }
}
