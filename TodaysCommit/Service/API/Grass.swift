import SwiftUI

enum GrassAPI {
  static func getGrass(_ mapId: Int) async throws -> GrassDataResponse {
    try await APIClient.shared.requestJSON(
      path: "/grass",
      query: [URLQueryItem(name: "map_id", value: String(mapId))],
      response: GrassDataResponse.self
    )
  }
    
  static func getMyGrass(_ mapId: Int) async throws -> GrassDataResponse {
    try await APIClient.shared.requestJSON(
      path: "/grass/mygrass",
      query: [URLQueryItem(name: "map_id", value: String(mapId))],
      response: GrassDataResponse.self,
      authRequired: true
    )
  }
}
