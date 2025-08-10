import SwiftUI

enum LocationAPI {
  static func getPnu(lat: Double, lon: Double) async throws -> PnuResponse {
    let baseURL = AppConfig.baseURL
    guard let url = URL(string:
                            
      "\(baseURL)/location?lat=\(lat)&lon=\(lon)"
    ) else {
      throw CustomError.networkError(NSError(domain: "URL 생성 실패", code: -1))
    }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(PnuResponse.self, from: data)
    } catch let error as DecodingError {
      throw CustomError.decodingError(error)
    } catch {
      throw CustomError.serverError(error)
    }
  }
}
