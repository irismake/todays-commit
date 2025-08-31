import SwiftUI

struct MyPlaceItem: View {
  var onTap: () async -> Void
  let placeData: PlaceData

  var body: some View {
    Button(action: {
      Task {
        await onTap()
      }
    }) {
      HStack(alignment: .center, spacing: 12) {
        CommitBadge(commitConut: placeData.commitCount)
            
        VStack(alignment: .leading, spacing: 12) {
          Text(placeData.name)
            .font(.headline)
            .foregroundColor(.primary)
            .lineLimit(1)

          Text(placeData.address)
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

struct MyPlaceItem_Previews: PreviewProvider {
  static var previews: some View {
    MyPlaceItem(
      onTap: {},
      placeData: PlaceData(
        pnu: "1168010100100010000",
        name: "파머스카페",
        address: "서울특별시 성북동 삼선동 1가 79",
        x: 37.8,
        y: 127.09,
        commitCount: 3
      )
    )
    .padding()
  }
}
