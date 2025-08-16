import Combine
import SwiftUI

final class PlaceService {
  static let shared = PlaceService()
  @StateObject private var locationManager = LocationManager()
  private init() {}

  func addPlace(of placeData: AddPlaceData) async {
    do {
      let response = try await PlaceAPI.addPlace(placeData)
    } catch {
      print("❌ addPlace : \(error.localizedDescription)")
    }
  }
    
  func getMainPlace(mapId: Int, coordId: Int, sort: String) async {
    do {
      guard let currentLocation = locationManager.currentLocation else {
        return
      }
        
      let response = try await PlaceAPI.getMainPlace(mapId: mapId, coordId: coordId, x: currentLocation.lat, y: currentLocation.lon, sort: sort)
      print(response)
    } catch {
      print("❌ getMainPlace : \(error.localizedDescription)")
    }
  }
}
