import Combine
import SwiftUI

enum PlaceScope: Hashable { case main, my }

private struct PlaceCacheKey: Hashable {
  let mapId: Int
  let coordId: Int
  let sort: SortOption
  let scope: PlaceScope
}

final class PlaceManager: ObservableObject {
  @Published private(set) var cachedPlaces: [PlaceSummary] = [] {
    didSet {
      totalCommitCount = cachedPlaces.reduce(0) { $0 + $1.commitCount }
    }
  }

  @Published private(set) var totalCommitCount: Int = 0
  @Published var placeSort: SortOption = .recent
  @Published var placeScope: PlaceScope = .main
  @Published var placeLocation: Location?

  private var cache: [PlaceCacheKey: [PlaceSummary]] = [:]
    
  @Published var placeDetail: PlaceDetail?

  private let mapManager: MapManager
  private var cancellables = Set<AnyCancellable>()

  init(mapManager: MapManager) {
    self.mapManager = mapManager
    bindMapChanges()
  }

  private func bindMapChanges() {
    let cell = mapManager.$selectedCell
      .removeDuplicates()
      .handleEvents(receiveOutput: { [weak self] value in
        if value == nil {
          Task { @MainActor in self?.cachedPlaces = [] }
        }
      })
      .compactMap { $0 }

    let sort = $placeSort.removeDuplicates()
    let scope = $placeScope.removeDuplicates()

    Publishers.CombineLatest3(cell, sort, scope)
      .receive(on: RunLoop.main)
      .sink { [weak self] cell, sort, scope in
        guard let self else {
          return
        }

        if self.mapManager.selectedGrassColor == .lv_0 {
          Task { @MainActor in self.cachedPlaces = [] }
          return
        }
        guard let mapId = self.mapManager.currentMapId else {
          Task { @MainActor in self.cachedPlaces = [] }
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

    guard let currentLocation = GlobalStore.shared.currentLocation else {
      print("⚠️ [NO LOCATION] cannot fetch")
      return
    }

    do {
      let sortParam = (sort == .recent) ? "recent" : "popular"

      let places: [PlaceSummary]
      switch scope {
      case .main:
        let res = try await PlaceAPI.getMainPlace(
          mapId: mapId,
          coordId: coordId,
          x: currentLocation.lat,
          y: currentLocation.lon,
          sort: sortParam
        )
        places = res.places

      case .my:
        let res = try await PlaceAPI.getMyPlace(
          mapId: mapId,
          coordId: coordId,
          x: currentLocation.lat,
          y: currentLocation.lon,
          sort: sortParam
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

  func addPlace(of placeData: PlaceData) async {
    do {
      _ = try await PlaceAPI.addPlace(placeData)
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
