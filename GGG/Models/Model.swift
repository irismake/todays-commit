import SwiftUI

struct Coord: Hashable {
  let x: Int
  let y: Int
}

struct RankUser: Decodable {
  let user_name: String
  let commit_count: Int
}

struct CommitData: Decodable {
  let x: Int
  let y: Int
  let total_commit_count: Int
  let rank_users: [RankUser]
}
