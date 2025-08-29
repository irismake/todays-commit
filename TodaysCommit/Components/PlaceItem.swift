import SwiftUI

struct PlaceItem: View {
  let placeData: PlaceData?
  let grassColor: Color
  var onTap: () async -> Void
    
  @State private var distance: String = "? m"
  @State private var commitCount: Int = 0
    
  var body: some View {
    Button(action: {
      Task {
        await onTap()
      }
    }) {
      if let placeData {
        HStack {
          VStack(alignment: .leading, spacing: 24) {
            Text(placeData.name)
              .font(.headline)
              .foregroundColor(.primary)
              .lineLimit(1)
                    
            HStack {
              HStack(spacing: 4) {
                Image(systemName: "location.fill")
                  .font(.system(size: 10, weight: .semibold))
                  .foregroundColor(.secondary)
                Text(distance)
                  .onAppear {
                    distance = GlobalStore.shared.getDistance(lat: placeData.x, lon: placeData.y)
                  }
                  .font(.caption)
                  .foregroundColor(.secondary)
              }

              HStack(spacing: 4) {
                Image("icon_commit")
                  .renderingMode(.template)
                  .foregroundColor(.secondary)
                  .aspectRatio(contentMode: .fit)
                  .frame(height: 10)
                     
                Text("\(placeData.commitCount)회")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
          }
               
          Spacer()

          Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.gray.opacity(0.6))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .stroke(grassColor.opacity(0.3), lineWidth: 1.5)
        )
        .shadow(color: grassColor.opacity(0.1), radius: 6, x: 0, y: 0)
      } else {
        Text("장소 정보를 불러오는 중...")
          .padding()
      }
    }
    .buttonStyle(.plain)
  }
}

struct PlaceItem_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      PlaceItem(placeData: PlaceData(pnu: "1168010100100320002", name: "스타벅스 무교로점", x: 37.437953, y: 127.3498305, commitCount: 1), grassColor: .lv_4, onTap: {})
      PlaceItem(placeData: PlaceData(pnu: "1168010100100320002", name: "스타벅스 무교로점", x: 37.437953, y: 127.3498305, commitCount: 1), grassColor: .lv_1, onTap: {},)
    }
    .padding()
  }
}
