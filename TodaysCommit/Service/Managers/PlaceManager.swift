import Combine
import SwiftUI

final class PlaceManager: ObservableObject {
  @Published private(set) var cachedPlaces: PlaceResponse = .init(nextCursor: nil, places: []) {
    didSet {
      totalCommitCount = cachedPlaces.places.reduce(0) { $0 + $1.commitCount }
    }
  }

  @Published private(set) var totalCommitCount: Int = 0
  @Published var placeSort: SortOption = .recent
  @Published var placeScope: PlaceScope = .main
  @Published var placeLocation: LocationBase?

  private var cache: [PlaceCacheKey: PlaceResponse] = [:]
  @Published private(set) var cacheKey: PlaceCacheKey = .init(mapId: 0, coordId: 0, sort: .recent, scope: .main)
    
  @Published var placeDetail: PlaceDetail?

  private let mapManager: MapManager
  private var cancellables = Set<AnyCancellable>()

  init(mapManager: MapManager) {
    self.mapManager = mapManager
    bindMapChanges()
  }

  private func bindMapChanges() {
    let cell = mapManager.$selectedCell
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
          self.cachedPlaces = PlaceResponse(nextCursor: nil, places: [])
          return
        }
        cacheKey = PlaceCacheKey(mapId: mapId, coordId: cell.coordId, sort: sort, scope: scope)
          
        Task {
          await self.fetchPlaces()
        }
      }
      .store(in: &cancellables)
  }

  @MainActor
  func invalidateAndReload(using cells: [CellResponse]) async {
    mapManager.mapLevel = 1

    for cell in cells {
      cache.keys
        .filter { $0.mapId == cell.mapId && $0.coordId == cell.cellData.coordId }
        .forEach { cache.removeValue(forKey: $0) }

      let mapId = cell.mapId
      let mapLevel = cell.mapLevel

      if mapLevel == 1 {
        await mapManager.fetchMapData(of: mapId, coordId: cell.cellData.coordId)
      }
    }
  }

  private func fetchPlaces() async {
    if let hit = cache[cacheKey] {
      await MainActor.run { cachedPlaces = hit }
      return
    }
    do {
      let sortParam = (cacheKey.sort == .recent) ? "recent" : "popular"
      let places: PlaceResponse
        
      switch cacheKey.scope {
      case .main:
        places = try await PlaceAPI.getMainPlace(
          mapId: cacheKey.mapId,
          coordId: cacheKey.coordId,
          sort: sortParam,
          cursor: nil
        )
      case .my:
        places = try await PlaceAPI.getMyPlace(
          mapId: cacheKey.mapId,
          coordId: cacheKey.coordId,
          sort: sortParam,
          cursor: nil
        )
      }

      await MainActor.run {
        cache[cacheKey] = places
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
