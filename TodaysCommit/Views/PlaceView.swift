import SwiftUI

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

struct PlaceView: View {
  @EnvironmentObject var mapManager: MapManager
  @EnvironmentObject var placeManager: PlaceManager
  @State private var activeSheet: Route?

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
          
        Text("총 커밋 \(placeManager.totalCommitCount)회")
          .font(.subheadline)
          .foregroundColor(.secondary)
          
        Spacer()
          
        GpsButton()
      }

      SortChips(
        selection: Binding(
          get: { placeManager.placeSort },
          set: { placeManager.placeSort = $0 }
        )
      )
       
      Group {
        if !placeManager.cachedPlaces.isEmpty {
          VStack(spacing: 12) {
            ForEach(placeManager.cachedPlaces, id: \.pnu) { placeData in
              PlaceItem(
                placeData: placeData,
                grassColor: mapManager.selectedGrassColor,
                onTap: {
                  if UserSessionManager.isGuest {
                    activeSheet = .login
                        
                  } else {
                    Task {
                      await placeManager.fetchPlaceDetail(of: placeData.pnu)
                      activeSheet = .commit
                    }
                  }
                },
              )
            }
          }
        } else {
          EmptyCard(title: "아직 잔디가 심어지기 전이에요. 😅", subtitle: "다른 곳을 눌러 잔디를 확인해보세요!")
        }
      }
    }
    
    .fullScreenCover(item: $activeSheet) { sheet in
      switch sheet {
      case .commit:
        PlaceDetailView()
      case .login:
        LoginView(isSheet: true)
      }
    }
  }
}
