struct PlaceChcek: Decodable {
  let exists: Bool
  let name: String?
}

struct PlaceData: Codable, Identifiable {
  var id: String { pnu }
  let pnu: String
  let name: String
  let address: String
  let x: Double
  let y: Double
}

struct PlaceSummary: Decodable {
  let pnu: String
  let name: String
  let distance: String
  let commitCount: Int
}

struct PlaceResponse: Decodable {
  let places: [PlaceSummary]
}

struct PlaceDetail: Decodable {
  var distance: String?
  var commitCount: Int?
  let pnu: String
  let name: String
  let address: String
  let x: Double
  let y: Double
  let commits: [PlaceCommitData]
}

struct PlaceCommitData: Decodable, Identifiable {
  var id: Int { commitId }
  let commitId: Int
  let userName: String
  let createdAt: String
}
