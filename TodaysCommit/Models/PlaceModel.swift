import SwiftUI

struct PlaceChcek: Decodable {
  let exists: Bool
  let name: String?
}

struct PlaceResponse: Codable, Identifiable {
  var id: String { pnu }
  let pnu: String
  let name: String
  let address: String
  let x: Double
  let y: Double
}
