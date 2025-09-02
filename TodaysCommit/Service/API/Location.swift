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

  static func searchLocation(query: String, x: Double?, y: Double?) async throws -> [SearchLocationData] {
    var queryItems = [
      URLQueryItem(name: "query", value: query),
      URLQueryItem(name: "radius", value: "1000")
    ]

    if let x {
      queryItems.append(URLQueryItem(name: "x", value: String(x)))
    }

    if let y {
      queryItems.append(URLQueryItem(name: "y", value: String(y)))
    }

    return try await APIClient.shared.requestJSON(
      path: "/location/search",
      query: queryItems,
      response: [SearchLocationData].self
    )
  }
}
