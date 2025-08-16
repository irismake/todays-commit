import Combine

final class PlaceService {
  static let shared = PlaceService()
  private init() {}
    
  @Published var placeLocation: Location?

  func addPlace(of placeData: AddPlaceData) async {
    do {
      let response = try await PlaceAPI.addPlace(placeData)
    } catch {
      print("❌ addPlace : \(error.localizedDescription)")
    }
  }
    
  func getMainPlace(mapId: Int, coordId: Int, sort: String) async {
    do {
      guard let location = GlobalStore.shared.currentLocation else {
        // 위치 권한 팝업
        return
      }

      let response = try await PlaceAPI.getMainPlace(mapId: mapId, coordId: coordId, x: location.lat, y: location.lon, sort: sort)
      print(response)
    } catch {
      print("❌ getMainPlace : \(error.localizedDescription)")
    }
  }
}
