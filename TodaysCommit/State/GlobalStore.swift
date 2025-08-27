import Foundation
import SwiftUI

final class GlobalStore {
  static let shared = GlobalStore()
  private init() {
    screenWidth = UIScreen.main.bounds.width
    screenHeight = UIScreen.main.bounds.height
  }
    
  var gridSize: Int = 22
  var screenWidth: CGFloat
  var screenHeight: CGFloat
  var currentLocation: LocationBase?

  func getDistance(lat: Double, lon: Double,) -> String {
    guard let myLoc = currentLocation else {
      print("⚠️ [NO LOCATION] cannot fetch")
      return "? m"
    }
    
    let R = 6371.0

    let dLat = (myLoc.lat - lat).radians
    let dLon = (myLoc.lon - lon).radians
    let placeLocRad = lat.radians
    let myLocRad = myLoc.lat.radians

    let a = sin(dLat / 2) * sin(dLat / 2) + cos(placeLocRad) * cos(myLocRad) * sin(dLon / 2) * sin(dLon / 2)
    let c = 2 * atan2(sqrt(a), sqrt(1 - a))

    let distance_km = R * c
    let distance_m = distance_km * 1000

    if distance_m >= 10000 {
      return "10km+"
    } else if distance_m >= 1000 {
      return String(format: "%.1fkm", distance_km)
    } else {
      return "\(Int(round(distance_m)))m"
    }
  }
}
