import SwiftUI

struct RequestOverlay: View {
  @Environment(\.dismiss) private var dismiss
  let requestMapName: String
  let onRequest: () -> Void

  @State private var shouldRunAfterDismiss = false

  var body: some View {
    VStack(spacing: 16) {
      Text("\(requestMapName) 지도 요청")
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.primary)

      Text("요청하신 지역은 서비스 개선에 참고할게요.\n함께 지도를 더 넓혀볼까요?")
        .font(.system(size: 14))
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 8)

      Button("확인") {
        shouldRunAfterDismiss = true
        dismiss()
      }
      .buttonStyle(.borderedProminent)
      .padding(.top, 8)
    }
    .padding(20)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(Color.white)
        .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
    )
    .frame(maxWidth: 300)
    .onDisappear {
      if shouldRunAfterDismiss {
        onRequest()
      }
    }
  }
}
