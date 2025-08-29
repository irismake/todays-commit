import SwiftUI

struct TotalViewButton: View {
  var body: some View {
    Button(action: {}) {
      HStack {
        Button(action: {}) {
          HStack(spacing: 6) {
            Image("icon_list")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(height: 10)
                        
            Text("전체")
              .font(.footnote)
              .foregroundColor(Color.white)
              .fontWeight(.bold)
          }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background {
          RoundedRectangle(cornerRadius: 8)
            .fill(Color(hex: "333333"))
        }
      }
    }
  }
}
