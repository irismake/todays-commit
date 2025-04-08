import SwiftUI

struct Coord: Hashable {
  let x: Int
  let y: Int
}

struct Zone: Hashable {
  let coord: Coord
  let zoneCode: Int

  init(x: Int, y: Int, zoneCode: Int) {
    coord = Coord(x: x, y: y)
    self.zoneCode = zoneCode
  }
}

struct RankUser: Decodable {
  let user_name: String
  let commit_count: Int
}

struct GrassCommit: Decodable {
  let x: Int
  let y: Int
  let total_commit_count: Int
  let rank_users: [RankUser]
}

class CommitViewModel: ObservableObject {
  @Published var selectedGrassCommit: GrassCommit? = nil
  @Published var selectedGrassColor: Color = .lv_0
  @Published var selectedZone: String = "잔디를 클릭해주세요."
}
