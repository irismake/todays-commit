import SwiftUI

struct SortOptionButton: View {
  @Binding var selection: SortOption

  var body: some View {
    ForEach(SortOption.allCases) { option in
      let isSelected = (option == selection)
                  
      Button {
        selection = option
      } label: {
        Text(option.rawValue)
          .font(.footnote)
          .fontWeight(isSelected ? .bold : .regular)
          .foregroundColor(isSelected ? .primary : Color.gray.opacity(0.5))
          .padding(.vertical, 8)
          .padding(.horizontal, 12)
          .background {
            if isSelected {
              Capsule()
                .stroke(Color.primary.opacity(0.7), lineWidth: 1.3)
            } else {
              Capsule()
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            }
          }
      }
      .buttonStyle(.plain)
    }
  }
}
