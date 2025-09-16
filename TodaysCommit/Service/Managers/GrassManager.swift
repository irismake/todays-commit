import SwiftUI

final class GrassManager: ObservableObject {
  @Published private(set) var cachedTotalGrass: GrassResponse?
  @Published private(set) var cachedMyGrass: GrassResponse?

  func addGrassData(of pnu: String) async -> [CellResponse] {
    do {
      let cells = try await GrassAPI.addGrass(pnu)

      for cell in cells {
        let mapId = cell.mapId
        let mapLevel = cell.mapLevel

        if mapLevel == 1 {
          if let total = cachedTotalGrass {
            if mapId == total.mapId {
              await fetchTotalGrassData(of: total.mapId)
            }
          }

          if let mine = cachedMyGrass {
            if mapId == mine.mapId {
              await fetchMyGrassData(of: mine.mapId)
            }
          }
        }
      }

      return cells
    } catch {
      print("❌ addGrassData : \(error.localizedDescription)")
      return []
    }
  }

  func fetchTotalGrassData(of mapId: Int) async {
    do {
      let response = try await GrassAPI.getGrass(mapId)
      await MainActor.run {
        cachedTotalGrass = response
      }
    } catch {
      print("❌ fetchTotalGrassData : \(error.localizedDescription)")
    }
  }

  func fetchMyGrassData(of mapId: Int) async {
    do {
      let response = try await GrassAPI.getMyGrass(mapId)
      await MainActor.run {
        cachedMyGrass = response
      }
    } catch {
      print("❌ fetchMyGrassData : \(error.localizedDescription)")
    }
  }
}
