struct UserBase: Codable {
  let userName: String
  let provider: String
}

struct UserResponse: Codable {
  let accessToken: String
  let userName: String
}
