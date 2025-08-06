import SwiftUI

enum UserAPI {
  static func loginWithKakao(_ token: String, completion: @escaping (Result<UserResponse, KakaoLoginError>) -> Void) {
    let base_url = AppConfig.baseURL
    guard let url = URL(string: "\(base_url)/user/login/kakao?access_token=\(token)") else {
      return completion(.failure(.networkError(NSError(domain: "URL 생성 실패", code: -1))))
    }

    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error {
        return completion(.failure(.serverError(error)))
      }

      guard let data else {
        return completion(.failure(.noData))
      }

      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(UserResponse.self, from: data)
        completion(.success(user))
      } catch {
        completion(.failure(.decodingError(error)))
      }
    }

    task.resume()
  }

  static func loginWithApple(authorizationCode: String, userName: String?, completion: @escaping (Result<UserResponse, AppleLoginError>) -> Void) {
    let baseURL = AppConfig.baseURL
    guard let url = URL(string: "\(baseURL)/oauth/apple/token") else {
      return completion(.failure(.networkError(NSError(domain: "URL 생성 실패", code: -1))))
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    var bodyComponents: [String: String] = ["code": authorizationCode]
    if let userName, !userName.isEmpty {
      bodyComponents["user_name"] = userName
    }
      
    request.httpBody = bodyComponents
      .map { "\($0.key)=\($0.value)" }
      .joined(separator: "&")
      .data(using: .utf8)

    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
      if let error {
        return completion(.failure(.serverError(error)))
      }

      guard let data else {
        return completion(.failure(.noData))
      }

      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let user = try decoder.decode(UserResponse.self, from: data)
        completion(.success(user))
      } catch {
        completion(.failure(.decodingError(error)))
      }
    }

    task.resume()
  }
}
