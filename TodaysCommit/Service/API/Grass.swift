import SwiftUI

enum GrassAPI {
  static func getGrass(_ mapId: Int) async throws -> GrassDataResponse {
    let baseURL = AppConfig.baseURL
    guard let url = URL(string: "\(baseURL)/grass?map_id=\(mapId)") else {
      throw CustomError.networkError(NSError(domain: "URL 생성 실패", code: -1))
    }
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(GrassDataResponse.self, from: data)
    } catch let error as DecodingError {
      throw CustomError.decodingError(error)
    } catch {
      throw CustomError.serverError(error)
    }
  }
}
