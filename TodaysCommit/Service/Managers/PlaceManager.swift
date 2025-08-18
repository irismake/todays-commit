import Combine
import SwiftUI

private struct PlaceCacheKey: Hashable {
  let mapId: Int
  let coordId: Int
  let sort: SortOption
}

final class PlaceManager: ObservableObject {
  @Published private(set) var cachedPlaces: [PlaceData] = [] {
    didSet {
      totalCommitCount = cachedPlaces.reduce(0) { $0 + $1.commitCount }
    }
  }

  @Published private(set) var totalCommitCount: Int = 0
  @Published var placeSort: SortOption = .recent
  @Published var placeLocation: Location?

  private var cache: [PlaceCacheKey: [PlaceData]] = [:]

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

    Publishers.CombineLatest(cell, sort)
      .receive(on: RunLoop.main)
      .sink { [weak self] cell, sort in
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

        Task { await self.fetchPlaces(mapId: mapId, coordId: cell.coordId, sort: sort) }
      }
      .store(in: &cancellables)
  }

  private func fetchPlaces(mapId: Int, coordId: Int, sort: SortOption, ignoreCache: Bool = false) async {
    let key = PlaceCacheKey(mapId: mapId, coordId: coordId, sort: sort)

    if !ignoreCache, let hit = cache[key] {
      await MainActor.run {
        cachedPlaces = hit
      }
      return
    }

    guard let currentLocation = GlobalStore.shared.currentLocation else {
      print("⚠️ [NO LOCATION] cannot fetch")
      return
    }

    do {
      let sortParam = (sort == .recent) ? "recent" : "popular"
      let response = try await PlaceAPI.getMainPlace(
        mapId: mapId,
        coordId: coordId,
        x: currentLocation.lat,
        y: currentLocation.lon,
        sort: sortParam
      )
      await MainActor.run {
        cache[key] = response.places
        cachedPlaces = response.places
      }
    } catch {
      print("❌ [API ERROR] \(error.localizedDescription)")
    }
  }

  func addPlace(of placeData: AddPlaceData) async {
    do {
      _ = try await PlaceAPI.addPlace(placeData)
    } catch {
      print("❌ addPlace : \(error.localizedDescription)")
    }
  }
}
