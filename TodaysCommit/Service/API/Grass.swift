import SwiftUI

enum GrassAPI {
  static func addGrass(_ pnu: String) async throws -> [CellResponse] {
    try await APIClient.shared.requestJSON(
      path: "/grass/\(pnu)",
      method: "POST",
      response: [CellResponse].self,
      authRequired: true
    )
  }
    
  static func getGrass(_ mapId: Int) async throws -> GrassResponse {
    try await APIClient.shared.requestJSON(
      path: "/grass",
      query: [URLQueryItem(name: "map_id", value: String(mapId))],
      response: GrassResponse.self
    )
  }
    
  static func getMyGrass(_ mapId: Int) async throws -> GrassResponse {
    try await APIClient.shared.requestJSON(
      path: "/grass/mygrass",
      query: [URLQueryItem(name: "map_id", value: String(mapId))],
      response: GrassResponse.self,
      authRequired: true
    )
  }
}
