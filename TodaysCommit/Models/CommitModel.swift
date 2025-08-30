struct CommitBase: Decodable {
  let commitId: Int
  let userId: Int
  let pnu: Int
  let createdAt: String
}

struct CommitData: Decodable, Identifiable {
  var id: Int { commitId }
  let commitId: Int
  let userName: String?
  let createdAt: String
  let pnu: Int?
  let placeName: String?
  let address: String?
}

struct CommitResponse: Decodable {
  let nextCursor: Int?
  let commits: [CommitData]
}
