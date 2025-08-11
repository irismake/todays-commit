import SwiftUI

struct Notification: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack(spacing: 16) {
      Text("잔디를 클릭해주세요")
        .font(.system(size: 20, weight: .bold))
        .foregroundColor(.primary)

      Text("확대하려면 먼저 잔디를 선택해 주세요.")
        .font(.system(size: 15))
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 8)

      Button {
        dismiss()
      } label: {
        Text("확인")
          .font(.system(size: 16, weight: .semibold))
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .tint(.green)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .padding(.top, 8)
    }
    .padding(20)
    .frame(maxWidth: 300)
    .background(Color.white)
    .cornerRadius(16)
    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 4)
  }
}
