import SwiftUI

enum PlaceAPI {
  static func checkPlace(_ pnu: String) async throws -> PlaceChcek {
    try await APIClient.shared.requestJSON(
      path: "/place/exist",
      query: [URLQueryItem(name: "pnu", value: pnu)],
      response: PlaceChcek.self,
      authRequired: true
    )
  }
    
  static func addPlace(_ placeData: PlaceResponse) async throws -> PlaceResponse {
    let bodyData = try? JSONEncoder().encode(
      placeData
    )
    return try await APIClient.shared.requestJSON(
      path: "/place",
      method: "POST",
      body: bodyData,
      response: PlaceResponse.self,
      authRequired: true
    )
  }
}
