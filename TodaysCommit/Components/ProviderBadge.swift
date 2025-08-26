import SwiftUI

struct ProviderBadge: View {
  let provider: String
    
  var body: some View {
    Text(provider)
      .padding(.vertical, 2)
      .padding(.horizontal, 10)
      .font(.caption2)
      .fontWeight(.bold)
      .foregroundColor(Color.black)
      .background(Color.yellow)
      .clipShape(RoundedRectangle(cornerRadius: 4))
  }
}
