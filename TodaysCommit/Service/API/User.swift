import SwiftUI

enum UserAPI {
  static func loginWithKakao(_ token: String, completion: @escaping (Result<UserResponse, KakaoLoginError>) -> Void) {
    let base_url = AppConfig.baseURL
    guard let url = URL(string: "\(base_url)/user/login/kakao?access_token=\(token)") else {
      return completion(.failure(.networkError(NSError(domain: "URL 생성 실패", code: -1))))
    }

    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      if let error {
        return completion(.failure(.networkError(error)))
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
