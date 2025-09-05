struct UserData: Codable {
  let userName: String
  let provider: String
}

struct UserResponse: Codable, Identifiable {
  var id: String { accessToken }
  let userName: String
  let email: String?
  let provider: String
  let createdAt: String
  let accessToken: String
  let isFirstLogin: Bool
}
