import SwiftUI

struct HistoryItem: View {
  var onTap: () async -> Void
  let placeName: String
  let placeAddress: String
  let pnu: String
    
  var body: some View {
    Button(action: {
      Task {
        await onTap()
      }
    }) {
      HStack {
        VStack(alignment: .leading, spacing: 12) {
          Text(placeName)
            .font(.headline)
            .foregroundColor(.primary)
            .lineLimit(1)
                    
          Text(placeAddress)
            .font(.caption)
            .foregroundColor(.secondary)
            .lineLimit(1)
        }
        Spacer()
      }
      .padding()
      .background(Color(.systemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .stroke(.primary.opacity(0.3), lineWidth: 1)
      )
      .shadow(color: .primary.opacity(0.1), radius: 6, x: 0, y: 0)
    }
    .buttonStyle(.plain)
  }
}

struct HistoryItem_Previews: PreviewProvider {
  static var previews: some View {
    HistoryItem(
      onTap: {},
      placeName: "파머스카페",
      placeAddress: "서울특별시 성북동 삼선동 1가 79",
      pnu: "1168010100100010000"
    )
    .padding()
  }
}
