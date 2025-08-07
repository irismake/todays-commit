import SwiftUI

struct PnuResponse: Decodable {
  let lat: Double
  let lon: Double
  let pnu: Int
}
