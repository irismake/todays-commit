import SwiftUI

enum MapAPI {
  static func getCell(_ pnu: Int) async throws -> [CellDataResponse] {
    let baseURL = AppConfig.baseURL
    guard let url = URL(string: "\(baseURL)/map/cell?pnu=\(pnu)") else {
      throw CustomError.networkError(NSError(domain: "URL 생성 실패", code: -1))
    }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode([CellDataResponse].self, from: data)
    } catch let error as DecodingError {
      throw CustomError.decodingError(error)
    } catch {
      throw CustomError.serverError(error)
    }
  }
    
  static func getMap(_ mapId: Int) async throws -> MapDataResponse {
    let baseURL = AppConfig.baseURL
    guard let url = URL(string: "\(baseURL)/map/\(mapId)") else {
      throw CustomError.networkError(NSError(domain: "URL 생성 실패", code: -1))
    }

    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      return try decoder.decode(MapDataResponse.self, from: data)
    } catch let error as DecodingError {
      throw CustomError.decodingError(error)
    } catch {
      throw CustomError.serverError(error)
    }
  }
}
