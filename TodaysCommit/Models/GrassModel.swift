import SwiftUI

struct GrassData: Decodable {
  let coordId: Int
  let commitCount: Int
}

struct GrassDataResponse: Decodable {
  let mapId: Int
  let grassData: [GrassData]
}
