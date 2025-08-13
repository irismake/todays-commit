import SwiftUI

enum LocationAPI {
  static func getPnu(lat: Double, lon: Double) async throws -> LocationResponse {
    let sLat = String(format: "%.7f", locale: Locale(identifier: "en_US_POSIX"), lat)
    let sLon = String(format: "%.7f", locale: Locale(identifier: "en_US_POSIX"), lon)
        
    return try await APIClient.shared.requestJSON(
      path: "/location",
      query: [URLQueryItem(name: "lat", value: sLat), URLQueryItem(name: "lon", value: sLon)],
      response: LocationResponse.self
    )
  }
}
