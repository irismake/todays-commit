import SwiftUI

enum CommitAPI {
  static func getMyCommit(of limit: Int) async throws -> CommitResponse {
    try await APIClient.shared.requestJSON(
      path: "/commit/mycommit",
      query: [URLQueryItem(name: "limit", value: String(limit))],
      response: CommitResponse.self,
      authRequired: true
    )
  }
}
