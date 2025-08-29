import SwiftUI

enum PlaceAPI {
  static func checkPlace(_ pnu: String) async throws -> PlaceChcek {
    try await APIClient.shared.requestJSON(
      path: "/place/exist",
      query: [URLQueryItem(name: "pnu", value: pnu)],
      response: PlaceChcek.self,
      authRequired: true
    )
  }
    
  static func addPlace(_ placeData: PlaceBase) async throws -> PostResponse {
    let bodyData = try? JSONEncoder().encode(
      placeData
    )
    return try await APIClient.shared.requestJSON(
      path: "/place",
      method: "POST",
      body: bodyData,
      response: PostResponse.self,
      authRequired: true
    )
  }
    
  static func getMainPlace(mapId: Int, coordId: Int, sort: String, cursor: String?) async throws -> PlaceResponse {
    var queryItems: [URLQueryItem] = [
      URLQueryItem(name: "map_id", value: String(mapId)), URLQueryItem(name: "coord_id", value: String(coordId)), URLQueryItem(name: "sort", value: sort), URLQueryItem(name: "limit", value: "10")
    ]
    if let cursor {
      queryItems.append(URLQueryItem(name: "cursor", value: cursor))
    }

    return try await APIClient.shared.requestJSON(
      path: "/place/main",
      query: queryItems,
      response: PlaceResponse.self,
    )
  }
    
  static func getMyPlace(mapId: Int, coordId: Int, sort: String, cursor: String?) async throws -> PlaceResponse {
    var queryItems: [URLQueryItem] = [URLQueryItem(name: "map_id", value: String(mapId)), URLQueryItem(name: "coord_id", value: String(coordId)), URLQueryItem(name: "sort", value: sort), URLQueryItem(name: "limit", value: "10")]
    if let cursor {
      queryItems.append(URLQueryItem(name: "cursor", value: cursor))
    }
   
    return try await APIClient.shared.requestJSON(
      path: "/place/myplace",
      query: queryItems,
      response: PlaceResponse.self,
      authRequired: true
    )
  }

  static func getMyPlaces(limit: Int = 10, cursor: String?) async throws -> PlaceResponse {
    var queryItems: [URLQueryItem] = [URLQueryItem(name: "limit", value: String(limit))]
    if let cursor {
      queryItems.append(URLQueryItem(name: "cursor", value: cursor))
    }
   
    return try await APIClient.shared.requestJSON(
      path: "/place/myplaces",
      query: queryItems,
      response: PlaceResponse.self,
      authRequired: true
    )
  }
    
  static func getPlaceDetail(_ pnu: String) async throws -> PlaceDetail {
    try await APIClient.shared.requestJSON(
      path: "/place/\(pnu)",
      response: PlaceDetail.self,
    )
  }
}
