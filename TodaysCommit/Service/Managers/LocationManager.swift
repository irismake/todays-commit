import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  private let manager = CLLocationManager()
   
  @Published var currentLocation: Location?
  @Published var authorizationStatus: CLAuthorizationStatus?
  @Published var isOverlayActive: Bool = false

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
    manager.requestWhenInUseAuthorization()
    manager.startUpdatingLocation()
  }

  func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let loc = locations.last else {
      return
    }

    let location = loc.coordinate
      
    currentLocation = Location(lat: location.latitude, lon: location.latitude)
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationStatus = manager.authorizationStatus
  }
    
  func deactivateOverlay() {
    isOverlayActive = false
  }

  func activateOverlay() {
    isOverlayActive = true
  }
}
