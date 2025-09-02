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

struct SearchLocationData: Decodable, Identifiable {
  var id: String { placeName + x + y }
  let placeName: String
  let addressName: String
  let roadAddressName: String?
  let x: String
  let y: String
  let distance: String?
}
