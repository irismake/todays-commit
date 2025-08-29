import Combine
import SwiftUI

private struct PlaceCacheKey: Hashable {
  let mapId: Int
  let coordId: Int
  let sort: SortOption
  let scope: PlaceScope
}

final class PlaceManager: ObservableObject {
  @Published private(set) var cachedPlaces: [PlaceData] = [] {
    didSet {
      totalCommitCount = cachedPlaces.reduce(0) { $0 + $1.commitCount }
    }
  }

  @Published private(set) var totalCommitCount: Int = 0
  @Published var placeSort: SortOption = .recent
  @Published var placeScope: PlaceScope = .main
  @Published var placeLocation: LocationBase?

  private var cache: [PlaceCacheKey: [PlaceData]] = [:]
    
  @Published var placeDetail: PlaceDetail?

  private let mapManager: MapManager
  private var cancellables = Set<AnyCancellable>()

  init(mapManager: MapManager) {
    self.mapManager = mapManager
    bindMapChanges()
  }

  private func bindMapChanges() {
    let cell = mapManager.$selectedCell.removeDuplicates()
    let sort = $placeSort.removeDuplicates()
    let scope = $placeScope.removeDuplicates()

    Publishers.CombineLatest3(cell, sort, scope)
      .receive(on: RunLoop.main)
      .sink { [weak self] _, sort, scope in
        guard let self else {
          return
        }
        guard let cell = self.mapManager.selectedCell,
              let mapId = self.mapManager.currentMapId,
              self.mapManager.selectedGrassColor != .lv_0
        else {
          self.cachedPlaces = []
          return
        }

        Task {
          await self.fetchPlaces(
            mapId: mapId,
            coordId: cell.coordId,
            sort: sort,
            scope: scope
          )
        }
      }
      .store(in: &cancellables)
  }

  private func fetchPlaces(
    mapId: Int,
    coordId: Int,
    sort: SortOption,
    scope: PlaceScope,
    ignoreCache: Bool = false
  ) async {
    let key = PlaceCacheKey(mapId: mapId, coordId: coordId, sort: sort, scope: scope)

    if !ignoreCache, let hit = cache[key] {
      await MainActor.run { cachedPlaces = hit }
      return
    }

    do {
      let sortParam = (sort == .recent) ? "recent" : "popular"

      let places: [PlaceData]
      switch scope {
      case .main:
        let res = try await PlaceAPI.getMainPlace(
          mapId: mapId,
          coordId: coordId,
          sort: sortParam,
          cursor: nil
        )
        places = res.places

      case .my:
        let res = try await PlaceAPI.getMyPlace(
          mapId: mapId,
          coordId: coordId,
          sort: sortParam,
          cursor: nil
        )
        places = res.places
      }

      await MainActor.run {
        cache[key] = places
        cachedPlaces = places
      }
    } catch {
      print("❌ [API ERROR] \(error.localizedDescription)")
    }
  }

  func addPlace(of placeData: PlaceBase) async {
    do {
      let res = try await PlaceAPI.addPlace(placeData)
      print("✅ addPlace: \(res.message)")
    } catch {
      print("❌ addPlace : \(error.localizedDescription)")
    }
  }
    
  @MainActor
  func fetchPlaceDetail(of pnu: String) async {
    let overlayVC = Overlay.show(LoadingView())
    defer { overlayVC.dismiss(animated: true) }
    do {
      let res = try await PlaceAPI.getPlaceDetail(pnu)
      placeDetail = res
    } catch {
      print("❌ fetchPlaceDetail : \(error.localizedDescription)")
    }
  }
}
