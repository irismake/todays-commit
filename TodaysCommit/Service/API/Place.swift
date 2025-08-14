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
}
