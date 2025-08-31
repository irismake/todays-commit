import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
   
  @Published var currentLocation: LocationBase?
  @Published var authorizationStatus: CLAuthorizationStatus?
  private let defaultLocation = LocationBase(lat: 37.5665, lon: 126.9780)

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
    currentLocation = defaultLocation
  }

  func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let loc = locations.last else {
      return
    }

    let location = loc.coordinate
      
    currentLocation = LocationBase(lat: location.latitude, lon: location.longitude)
    GlobalStore.shared.currentLocation = currentLocation
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
  }
}
