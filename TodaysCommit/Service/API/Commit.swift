import SwiftUI

enum CommitAPI {
  static func getMyCommit(cursor: Int?) async throws -> CommitResponse {
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "limit", value: String(10))
    ]
       
    if let cursor {
      queryItems.append(URLQueryItem(name: "cursor", value: String(cursor)))
    }

    return try await APIClient.shared.requestJSON(
      path: "/commit/mycommit",
      query: queryItems,
      response: CommitResponse.self,
      authRequired: true
    )
  }
}
