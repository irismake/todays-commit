import Combine
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
   
  @Published var currentLocation: LocationBase?
  @Published var currentAddress: String = "현재 위치 가져오는중.."
  @Published var authorizationStatus: CLAuthorizationStatus?

  @Published var query: String = ""
  @Published var searchResults: [SearchLocationData] = []
    
  private var cancellables = Set<AnyCancellable>()
    
  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
    
    $query
      .removeDuplicates()
      .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
      .sink { [weak self] text in
        guard let self, !text.isEmpty else {
          self?.searchResults = []
          return
        }
        Task {
          await self.searchPlaces(query: text)
        }
      }
      .store(in: &cancellables)
  }

  func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let loc = locations.last else {
      return
    }

    let location = loc.coordinate
      
    currentLocation = LocationBase(lat: location.latitude, lon: location.longitude)
    GlobalStore.shared.currentLocation = currentLocation
    manager.stopUpdatingLocation()
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
    if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
      manager.startUpdatingLocation()
    }
  }

  @MainActor
  func searchPlaces(query: String) async {
    do {
      let places = try await LocationAPI.searchLocation(query: query, x: currentLocation?.lat, y: currentLocation?.lon)
      searchResults = places
    } catch {
      print("searchPlaces:", error.localizedDescription)
      searchResults = []
    }
  }
}
