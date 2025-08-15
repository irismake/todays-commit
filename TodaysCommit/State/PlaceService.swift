import Combine
import SwiftUI

final class PlaceService {
  static let shared = PlaceService()
  private init() {}

  func addPlace(of placeData: PlaceResponse) async {
    do {
      let response = try await PlaceAPI.addPlace(placeData)
    } catch {
      print("❌ fetchGrassData : \(error.localizedDescription)")
    }
  }
}
