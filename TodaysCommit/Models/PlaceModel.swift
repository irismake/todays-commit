struct PlaceChcek: Decodable {
  let exists: Bool
  let name: String?
}

struct PlaceBase: Codable, Identifiable {
  var id: String { pnu }
  let pnu: String
  let name: String
  let address: String
  let x: Double
  let y: Double
}

struct PlaceData: Decodable, Identifiable {
  var id: String { pnu }
  let pnu: String
  let name: String
  let address: String
  let x: Double
  let y: Double
  let commitCount: Int
}

struct PlaceResponse: Decodable {
  let nextCursor: String?
  let places: [PlaceData]
}

struct PlaceDetail: Decodable {
  let pnu: String
  let name: String
  let address: String
  let x: Double
  let y: Double
  let commits: [CommitData]
}
