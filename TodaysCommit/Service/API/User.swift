import SwiftUI

enum UserAPI {
  static func loginWithKakao(_ token: String, completion: @escaping (Result<UserResponse, KakaoLoginError>) -> Void) {
    let overlayVC = Overlay.show(LoadingView())
      
    let base_url = AppConfig.baseURL
    guard let url = URL(string: "\(base_url)/user/login/kakao?access_token=\(token)") else {
      return completion(.failure(.networkError(NSError(domain: "URL 생성 실패", code: -1))))
    }

    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      DispatchQueue.main.async {
        overlayVC.dismiss(animated: true)
      }
    
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
    let overlayVC = Overlay.show(LoadingView())
   
    let baseURL = AppConfig.baseURL
    guard let url = URL(string: "\(baseURL)/oauth/apple/token") else {
      return completion(.failure(.networkError(NSError(domain: "URL 생성 실패", code: -1))))
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    var components = URLComponents()
    var items = [URLQueryItem(name: "code", value: authorizationCode)]
    if let userName, !userName.isEmpty {
      items.append(URLQueryItem(name: "user_name", value: userName))
    }
    components.queryItems = items

    request.httpBody = components.percentEncodedQuery?.data(using: .utf8)
    request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
      DispatchQueue.main.async {
        overlayVC.dismiss(animated: true)
      }
      
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

  static func getUserInfo() async throws -> UserData {
    try await APIClient.shared.requestJSON(
      path: "/user/info",
      response: UserData.self,
      authRequired: true
    )
  }
    
  static func logoutUser() async throws -> PostResponse {
    try await APIClient.shared.requestJSON(
      path: "/user/logout",
      method: "POST",
      response: PostResponse.self,
      authRequired: true
    )
  }

  static func leaveUser() async throws -> PostResponse {
    try await APIClient.shared.requestJSON(
      path: "/user/leave",
      method: "POST",
      response: PostResponse.self,
      authRequired: true
    )
  }
}
