import Combine
import SwiftUI

final class GrassService {
  static let shared = GrassService()
  private init() {}

  private var cachedTotalGrass: GrassDataResponse?
  private var cachedMyGrass: GrassDataResponse?

  func getTotalCachedGrass() -> GrassDataResponse? { cachedTotalGrass }
  func getMyCachedGrass() -> GrassDataResponse? { cachedMyGrass }

  func addGrassData(of pnu: String) async {
    do {
      _ = try await GrassAPI.addGrass(pnu)
    } catch {
      print("❌ fetchGrassData : \(error.localizedDescription)")
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
