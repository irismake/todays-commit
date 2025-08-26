struct CommitBase: Decodable {
  let commitId: Int
  let userId: Int
  let pnu: Int
  let createdAt: String
}

struct PostResponse: Decodable {
  let message: String
}

struct CommitData: Decodable, Identifiable {
  var id: Int { commitId }
  let commitId: Int
  let userName: String?
  let createdAt: String
  let pnu: Int?
  let name: String?
  let address: String?
}
