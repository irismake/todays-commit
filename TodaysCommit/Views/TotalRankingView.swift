import SwiftUI

struct TotalRankingView: View {
  @EnvironmentObject var mapManager: MapManager
  private let placeService = PlaceService.shared
  @State private var cachedPlaces: [PlaceData]? = nil

  private var totalCommitCount: Int {
    cachedPlaces?.reduce(0) { $0 + $1.commitCount } ?? 0
  }

  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Image(systemName: "app.fill")
          .font(.headline)
          .foregroundColor(mapManager.selectedGrassColor)

        Text(mapManager.selectedZoneName)
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)

        Text("총 커밋 \(totalCommitCount)회")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      Group {
        if mapManager.selectedGrassColor == .lv_0 {
          EmptyGrassCard()

        } else if let mainPlaces = cachedPlaces, !mainPlaces.isEmpty {
          VStack(spacing: 12) {
            ForEach(mainPlaces.indices, id: \.self) { idx in
              PlaceItem(
                placeName: mainPlaces[idx].name,
                distance: mainPlaces[idx].distance,
                commitCount: mainPlaces[idx].commitCount
              )
            }
          }

        } else {
          EmptyGrassCard()
        }
      }
    }
    .onAppear {
      cachedPlaces = placeService.getMainCachedPlace()
    }
    .onChange(of: mapManager.selectedCell) {
      cachedPlaces = placeService.getMainCachedPlace()
    }
  }
}

private struct EmptyGrassCard: View {
  var body: some View {
    VStack(spacing: 12) {
      Text("아직 잔디가 심어지기 전이에요. 😅")
        .font(.headline)
        .foregroundColor(.secondary)
      Text("다른 곳을 눌러 잔디를 확인해보세요!")
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color.lv_0.opacity(0.4))
    .cornerRadius(16)
  }
}
