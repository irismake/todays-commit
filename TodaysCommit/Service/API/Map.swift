import SwiftUI

enum MapAPI {
  static func getCell(_ pnu: String) async throws -> [CellDataResponse] {
    try await APIClient.shared.requestJSON(
      path: "/map/cell",
      query: [URLQueryItem(name: "pnu", value: pnu)],
      response: [CellDataResponse].self
    )
  }
    
  static func getMap(_ mapId: Int) async throws -> MapDataResponse {
    try await APIClient.shared.requestJSON(
      path: "/map/\(mapId)",
      response: MapDataResponse.self
    )
  }
}
