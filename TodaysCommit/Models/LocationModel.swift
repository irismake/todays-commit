import SwiftUI

struct Location: Hashable {
  let lat: Double
  let lon: Double
}

struct LocationResponse: Decodable {
  let lat: Double
  let lon: Double
  let pnu: Int
  let address: String
}
