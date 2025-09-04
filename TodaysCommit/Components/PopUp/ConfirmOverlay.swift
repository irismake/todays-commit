import SwiftUI

struct ConfirmOverlay: View {
  let title: String
  let content: String
  let showToast: Bool

  init(title: String, content: String, showToast: Bool = false) {
    self.title = title
    self.content = content
    self.showToast = showToast
  }
    
  var body: some View {
    VStack(spacing: 16) {
      Text(title)
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.primary)

      Text(content)
        .font(.system(size: 14))
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 8)

      Button("확인") {
        if showToast {
          Overlay.dismiss(animated: true) {
            Overlay.show(Toast(message: "요청이 완료되었습니다."), autoDismissAfter: 2)
          }
        } else {
          Overlay.dismiss(animated: true)
        }
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
  }
}
