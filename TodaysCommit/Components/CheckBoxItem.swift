import SwiftUI

struct CheckBoxItem: View {
  let title: String
  let url: String
  @Binding var isOn: Bool

  var body: some View {
    HStack {
      Button(action: { isOn.toggle() }) {
        Image(systemName: isOn ? "checkmark.square.fill" : "square")
          .foregroundColor(isOn ? .blue : .gray)
          .font(.system(size: 22))
      }
      .buttonStyle(PlainButtonStyle())

      Text(title)
        .font(.subheadline)
      
      Spacer()
      
      Button(action: {
        if let link = URL(string: url) {
          UIApplication.shared.open(link)
        }
      }) {
        Image(systemName: "chevron.right")
          .imageScale(.small)
          .foregroundColor(.secondary)
      }
    }
    .padding(.vertical, 4)
  }
}
