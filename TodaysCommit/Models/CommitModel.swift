import SwiftUI

struct CommitData: Decodable {
  let commitId: Int
  let userId: Int
  let pnu: Int
  let createdAt: String
}

struct CommitResponse: Decodable {
  let message: String
  let commit: CommitData
}
