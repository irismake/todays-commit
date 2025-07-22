import SwiftUI

struct RankingItem: View {
  var backgroundColor: Color
  var user: String
  var commitCount: Int

  var body: some View {
    Button(action: {}) {
      HStack(spacing: 18) {
        Image(systemName: "person.circle.fill")
          .font(.system(size: 30, weight: .bold))
          .frame(width: 20, height: 20)
          .foregroundColor(Color(.systemGray))
        Text(user)
          .font(.headline)
          .foregroundColor(.black)
        Spacer()
        Text("커밋 \(commitCount)회")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .padding()
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(backgroundColor)
    .cornerRadius(16)
  }
}

struct RankingItem_Previews: PreviewProvider {
  static var previews: some View {
    RankingItem(backgroundColor: Color.yellow.opacity(0.1), user: "irismake", commitCount: 125)
  }
}
