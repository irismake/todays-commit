import SwiftUI

final class GrassManager: ObservableObject {
  @Published private(set) var cachedTotalGrass: GrassResponse?
  @Published private(set) var cachedMyGrass: GrassResponse?

  func addGrassData(of pnu: String) async -> [CellResponse] {
    do {
      let res = try await GrassAPI.addGrass(pnu)

      if let total = cachedTotalGrass {
        for cell in res {
          if cell.mapId == total.mapId {
            await fetchTotalGrassData(of: total.mapId)
            break
          }
        }
      }

      if let mine = cachedMyGrass {
        for cell in res {
          if cell.mapId == mine.mapId {
            await fetchMyGrassData(of: mine.mapId)
            break
          }
        }
      }

      return res
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
