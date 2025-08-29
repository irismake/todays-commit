import SwiftUI

struct TotalPlacesView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var mapManager: MapManager
  @EnvironmentObject var placeManager: PlaceManager
  @State private var activeSheet: Route?
  @State private var myPlaces: [PlaceData] = []
  @State private var nextCursor: String?
  @State private var placeKey: PlaceCacheKey = .init(mapId: 0, coordId: 0, sort: .recent, scope: .main)

  @State private var isLoading = false

  var body: some View {
    VStack {
      ZStack {
        Text(mapManager.selectedZoneName)
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
               
        if !myPlaces.isEmpty {
          HStack {
            Text(mapManager.selectedZoneName)
              .font(.headline)
              .fontWeight(.semibold)
              .opacity(0)

            Text((placeKey.sort == .recent) ? "최신순" : "인기순")
              .font(.caption2)
              .fontWeight(.bold)
              .foregroundColor(.primary)
              .padding(.vertical, 4)
              .padding(.horizontal, 6)
              .background {
                Capsule()
                  .stroke(Color.primary.opacity(0.7), lineWidth: 1.3)
              }
              .padding(.leading, 50)
          }
        }
               
        HStack {
          Spacer()
          Button(action: { dismiss() }) {
            Image(systemName: "xmark")
              .foregroundColor(.primary)
          }
        }
      }
      .padding()

      if !myPlaces.isEmpty {
        ScrollView(showsIndicators: false) {
          LazyVStack(spacing: 20) {
            ForEach(Array(myPlaces.enumerated()), id: \.element.id) { index, place in
              HStack(spacing: 16) {
                Text("\(index + 1)")
                  .font(.headline)
                                
                PlaceItem(
                  placeData: place,
                  grassColor: Color.green,
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
              .padding(.horizontal)
            }
                        
            if nextCursor != nil {
              ProgressView()
                .onAppear {
                  fetchTotalPlaces()
                }
            } else {
              Text("모든 장소를 불러왔습니다.")
                .font(.subheadline)
                .foregroundColor(.secondary.opacity(0.5))
                .padding()
            }
          }
          .padding(.top, 20)
        }
      } else {
        EmptyCard(title: "아직 잔디가 심어지기 전이에요.", subtitle: "다른 곳을 눌러 잔디를 확인해보세요.")
          .padding()
        Spacer()
      }
    }
    .onAppear {
      myPlaces = placeManager.cachedPlaces.places
      nextCursor = placeManager.cachedPlaces.nextCursor
      placeKey = placeManager.cacheKey
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
  
  private func fetchTotalPlaces() {
    guard !isLoading else {
      return
    }
    isLoading = true
        
    Task {
      let overlayVC = Overlay.show(LoadingView())
      defer {
        overlayVC.dismiss(animated: true)
        isLoading = false
      }
            
      do {
        let sortParam = (placeKey.sort == .recent) ? "recent" : "popular"
        let placeRes: PlaceResponse
        switch placeKey.scope {
        case .main:
          let res = try await PlaceAPI.getMainPlace(
            mapId: placeKey.mapId,
            coordId: placeKey.coordId,
            sort: sortParam,
            cursor: nextCursor
          )
          placeRes = res
            
        case .my:
          let res = try await PlaceAPI.getMyPlace(
            mapId: placeKey.mapId,
            coordId: placeKey.coordId,
            sort: sortParam,
            cursor: nextCursor
          )
          placeRes = res
        }
        myPlaces.append(contentsOf: placeRes.places)
        nextCursor = placeRes.nextCursor
            
        print("✅ Fetched \(placeRes.places.count) new commits. Next cursor: \(String(describing: nextCursor))")
      } catch {
        print("❌ getTotalPlaces: \(error.localizedDescription)")
        nextCursor = nil
      }
    }
  }
}
