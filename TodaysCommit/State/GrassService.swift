import Combine
import SwiftUI

final class GrassService {
  static let shared = GrassService()
  private init() {}

  private var cachedGrassData: GrassDataResponse?

  func getCachedGrassData() -> GrassDataResponse? { cachedGrassData }

  func fetchGrassData(of mapId: Int) async -> [GrassData] {
    do {
      let response = try await GrassAPI.getGrass(mapId)
      cachedGrassData = response
      return response.grassData
    } catch {
      print("❌ fetchGrassData : \(error.localizedDescription)")
      return []
    }
  }
}
