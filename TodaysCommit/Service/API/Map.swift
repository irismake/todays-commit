import SwiftUI

enum MapAPI {
  static func getCell(_ pnu: String) async throws -> [CellResponse] {
    try await APIClient.shared.requestJSON(
      path: "/map/cell",
      query: [URLQueryItem(name: "pnu", value: pnu)],
      response: [CellResponse].self
    )
  }
    
  static func getMap(_ mapId: Int) async throws -> MapResponse {
    try await APIClient.shared.requestJSON(
      path: "/map/\(mapId)",
      response: MapResponse.self
    )
  }
}
