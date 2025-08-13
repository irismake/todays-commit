import SwiftUI

enum GrassAPI {
  static func getGrass(_ mapId: Int) async throws -> GrassDataResponse {
    let baseURL = AppConfig.baseURL
    guard let url = URL(string: "\(baseURL)/grass?map_id=\(mapId)") else {
      throw APIError.network(NSError(domain: "URL 생성 실패", code: -1))
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(GrassDataResponse.self, from: data)
    } catch let error as DecodingError {
      throw APIError.decoding(error)
    } catch {
      throw APIError.server(error)
    }
  }
    
  static func getMyGrass(_ mapId: Int) async throws -> GrassDataResponse {
    let baseURL = AppConfig.baseURL
    guard let url = URL(string: "\(baseURL)/grass/mygrass?map_id=\(mapId)") else {
      throw APIError.network(NSError(domain: "URL 생성 실패", code: -1))
    }

    let accessToken = UserSessionManager.accessToken

    var request = URLRequest(url: url)
    print(accessToken)
    request.httpMethod = "GET"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
      let (data, _) = try await URLSession.shared.data(for: request)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(GrassDataResponse.self, from: data)
    } catch let error as DecodingError {
      throw APIError.decoding(error)
    } catch {
      throw APIError.server(error)
    }
  }
}
