import SwiftUI

struct Location: Hashable {
  let lat: Double
  let lon: Double
}

struct PnuResponse: Decodable {
  let lat: Double
  let lon: Double
  let pnu: Int
}
