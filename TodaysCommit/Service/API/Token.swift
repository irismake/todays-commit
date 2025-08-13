import SwiftUI

enum TokenAPI {
  static func updateToken() async throws {
    let baseURL = AppConfig.baseURL
    guard let url = URL(string: "\(baseURL)/token/update") else {
      throw CustomError.invalidURL
    }
    guard let access = UserSessionManager.accessToken, !access.isEmpty else {
      throw CustomError.tokenMissing
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("Bearer \(access)", forHTTPHeaderField: "Authorization")

    let (data, resp) = try await URLSession.shared.data(for: request)
    guard let http = resp as? HTTPURLResponse else {
      throw CustomError.noData
    }
    if http.statusCode == 401 {
      throw CustomError.unauthorized
    }
    guard (200 ... 299).contains(http.statusCode) else {
      throw CustomError.serverError(statusCode: http.statusCode, data: data)
    }

    do {
      let decoder = JSONDecoder()
      let res = try decoder.decode(String.self, from: data)
      UserSessionManager.updateAccessToken(res)
    } catch {
      throw CustomError.decodingError(error)
    }
  }
}
