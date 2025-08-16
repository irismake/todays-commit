import SwiftUI

struct PlaceItem: View {
  var commitCount: Int

  var body: some View {
    Button(action: {}) {
      HStack {
        VStack(alignment: .leading, spacing: 20) {
          Text("커피스토어")
            .font(.headline)
            .foregroundColor(.primary)
            .lineLimit(1)
              
          HStack {
            HStack(spacing: 4) {
              Image(systemName: "location.fill")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(Color(red: 194 / 255, green: 194 / 255, blue: 194 / 255))
              Text("3m")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.6))
            }

            HStack(spacing: 4) {
              Image("icon_commit")
                .font(.system(size: 10, weight: .semibold))
               
              Text("\(commitCount)회")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.6))
            }
          }
        }
         
        Spacer()
         
        // 오른쪽 인디케이터
        Image(systemName: "chevron.right")
          .font(.system(size: 12, weight: .semibold))
          .foregroundColor(.gray.opacity(0.6))
      }
      .padding()
      .background(Color.green.opacity(0.1))
      .cornerRadius(16)
      .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    .buttonStyle(.plain)
  }
}

struct PlaceItem_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      PlaceItem(commitCount: 125)
      PlaceItem(commitCount: 42)
    }
    .padding()
  }
}
