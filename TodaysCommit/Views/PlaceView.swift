import SwiftUI

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
        
      HStack(spacing: 16) {
        TotalPlaceButton()
        HStack {
          SortOptionButton(
            selection: Binding(
              get: { placeManager.placeSort },
              set: { placeManager.placeSort = $0 }
            )
          )
        }
      }

      Group {
        if !placeManager.cachedPlaces.places.isEmpty {
          VStack(spacing: 12) {
            ForEach(placeManager.cachedPlaces.places, id: \.pnu) { place in
              PlaceItem(
                placeData: place,
                grassColor: mapManager.selectedGrassColor,
                onTap: {
                  if UserSessionManager.isGuest {
                    activeSheet = .login
                  } else {
                    Task {
                      await placeManager.fetchPlaceDetail(of: place.pnu)
                      activeSheet = .placeDetail
                    }
                  }
                }
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
      case .placeDetail:
        PlaceDetailView()
      case .login:
        LoginView(isSheet: true)
      default:
        EmptyView()
      }
    }
  }
}
