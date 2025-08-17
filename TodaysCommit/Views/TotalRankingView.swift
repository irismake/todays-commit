import SwiftUI

private enum SortOption: String, CaseIterable, Identifiable {
  case recent = "최신순"
  case popular = "인기순"
  var id: String { rawValue }
}

private struct SortChips: View {
  @Binding var selection: SortOption
  @Namespace private var underlineNS

  var body: some View {
    HStack(spacing: 16) {
      ForEach(SortOption.allCases) { option in
        let isSelected = (option == selection)

        Button {
          if selection != option {
            selection = option
          }
        } label: {
          VStack(spacing: 6) {
            Text(option.rawValue)
              .font(.footnote)
              .fontWeight(.bold)
              .foregroundColor(isSelected ? .primary : .secondary)
              .padding(.horizontal, 6)
            if isSelected {
              Capsule()
                .fill(Color.primary)
                .frame(height: 2)
                .matchedGeometryEffect(id: "sort_underline", in: underlineNS)
            } else {
              Color.clear.frame(height: 2)
            }
          }
          .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
      }
    }
    .fixedSize(horizontal: true, vertical: false)
  }
}

struct TotalRankingView: View {
  @EnvironmentObject var mapManager: MapManager
  private let placeService = PlaceService.shared
  @State private var cachedPlaces: [PlaceData]? = nil
  @State private var sortOption: SortOption = .recent

  private var totalCommitCount: Int {
    cachedPlaces?.reduce(0) { $0 + $1.commitCount } ?? 0
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 20) {
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

      SortChips(selection: $sortOption)
       
      Group {
        if mapManager.selectedGrassColor == .lv_0 {
          EmptyGrassCard()

        } else if let mainPlaces = cachedPlaces, !mainPlaces.isEmpty {
          VStack(spacing: 12) {
            ForEach(mainPlaces.indices, id: \.self) { idx in
              PlaceItem(
                placeName: mainPlaces[idx].name,
                distance: mainPlaces[idx].distance,
                commitCount: mainPlaces[idx].commitCount,
                grassColor: mapManager.selectedGrassColor
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
