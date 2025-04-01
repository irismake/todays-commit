import SwiftUI

struct Coord: Hashable {
  let x: Int
  let y: Int
  let location: String?
    
  init(x: Int, y: Int, location: String? = nil) {
    self.x = x
    self.y = y
    self.location = location
  }
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

class CommitViewModel: ObservableObject {
  @Published var selectedCommitData: CommitData? = nil
  @Published var selectedGrassColor: Color = .lv_0
  @Published var selectedLocationData: String? = "잔디를 클릭해주세요."
}
