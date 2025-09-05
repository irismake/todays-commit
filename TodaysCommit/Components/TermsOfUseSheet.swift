import SwiftUI

struct TermsOfUseSheet: View {
  @Environment(\.dismiss) private var dismiss
  var onAgree: () -> Void

  @State private var agreeService = false
  @State private var agreeMarketing = false

  private var isRequiredAgreed: Bool {
    agreeService
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("약관 동의")
        .font(.headline)
        .fontWeight(.bold)
        .padding(.vertical)

      CheckBoxItem(
        title: "[필수] 서비스 이용약관 동의",
        url: GlobalStore.shared.termsOfUseUrl,
        isOn: $agreeService
      )

      CheckBoxItem(
        title: "[선택] 마케팅 정보 수신 동의",
        url: GlobalStore.shared.marketingAgreeUrl,
        isOn: $agreeMarketing
      )

      Spacer()
          
      CompleteButton(onComplete: {
        onAgree()
        dismiss()
      }, title: "동의하고 계속하기", color: isRequiredAgreed ? Color.green : Color.gray.opacity(0.4))
        .disabled(!isRequiredAgreed)
    }
    .padding()
    .interactiveDismissDisabled(true)
    .presentationDetents([
      .height(UIScreen.main.bounds.height * 0.3)
    ])
    .presentationCornerRadius(20)
  }
}
