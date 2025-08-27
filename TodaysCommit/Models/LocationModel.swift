struct LocationBase: Hashable {
  let lat: Double
  let lon: Double
}

struct LocationResponse: Decodable {
  let lat: Double
  let lon: Double
  let pnu: String
  let address: String
}
