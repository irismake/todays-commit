import SwiftUI

struct CommitBanner: View {
  var commitState: Bool

  var body: some View {
    Button(action: {}) {
      VStack(spacing: 12) {
        Label(
          commitState ? "오늘 커밋 완료!" : "오늘 커밋을 시작해보세요!",
          systemImage: commitState ? "checkmark.circle.fill" : "bolt.fill"
        )
        .font(.headline)
        .foregroundColor(commitState ? .green : .orange)

        Text(commitState ? "잔디를 지도에 심어보세요." : "커밋하고 잔디를 키워보세요.")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(commitState ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
      .cornerRadius(16)
    }
  }
}
