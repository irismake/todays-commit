import Combine
import SwiftUI

final class GrassService {
  static let shared = GrassService()
  private init() {}

  private var cachedTotalGrass: GrassResponse?
  private var cachedMyGrass: GrassResponse?

  func getTotalCachedGrass() -> GrassResponse? { cachedTotalGrass }
  func getMyCachedGrass() -> GrassResponse? { cachedMyGrass }

  func addGrassData(of pnu: String) async -> [CellBase] {
    do {
      let res = try await GrassAPI.addGrass(pnu)
      return res
    } catch {
      print("❌ fetchGrassData : \(error.localizedDescription)")
      return []
    }
  }

  func fetchTotalGrassData(of mapId: Int) async -> [GrassData] {
    do {
      let response = try await GrassAPI.getGrass(mapId)
      cachedTotalGrass = response
      return response.grassData
    } catch {
      print("❌ fetchGrassData : \(error.localizedDescription)")
      return []
    }
  }
    
  func fetchMyGrassData(of mapId: Int) async -> [GrassData] {
    do {
      let response = try await GrassAPI.getMyGrass(mapId)
      cachedMyGrass = response
      return response.grassData
    } catch {
      print("❌ fetchGrassData : \(error.localizedDescription)")
      return []
    }
  }
}
