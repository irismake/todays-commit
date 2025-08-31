import SwiftUI

struct PlaceItem: View {
  let placeData: PlaceData?
  let grassColor: Color
  var onTap: () async -> Void
    
  @State private var distance: String = "? m"
    
  var body: some View {
    Button(action: {
      Task {
        await onTap()
      }
    }) {
      if let placeData {
        HStack(alignment: .top, spacing: 16) {
          VStack {
            CommitBadge(commitConut: placeData.commitCount)
            Spacer()
          }
              
          VStack(alignment: .leading, spacing: 10) {
            Text(placeData.name)
              .font(.headline)
              .fontWeight(.semibold)
              .foregroundColor(.primary)
              .lineLimit(1)
              
            Text(placeData.address)
              .font(.caption)
              .foregroundColor(.secondary)
              .lineLimit(1)
  
            HStack(spacing: 4) {
              Image(systemName: "location.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 8, height: 8)
                .foregroundColor(.secondary)

              Text(distance)
                .onAppear {
                  distance = GlobalStore.shared.getDistance(lat: placeData.x, lon: placeData.y)
                }
                .font(.caption2)
                .foregroundColor(.secondary)
            }
          }
              
          Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(grassColor.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: grassColor.opacity(0.2), radius: 6, x: 0, y: 0)
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
      } else {
        Text("장소 정보를 불러오는 중...")
          .padding()
      }
    }
  }
}

struct PlaceItem_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      PlaceItem(placeData: PlaceData(pnu: "1168010100100320002", name: "스타벅스 무교로점", address: "서울 중구 세종대로 110", x: 37.437953, y: 127.3498305, commitCount: 1), grassColor: .lv_4, onTap: {})
      PlaceItem(placeData: PlaceData(pnu: "1168010100100320002", name: "스타벅스 무교로점", address: "서울 중구 세종대로 110", x: 37.437953, y: 127.3498305, commitCount: 1), grassColor: .lv_1, onTap: {},)
    }
    .padding()
  }
}
