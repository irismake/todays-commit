import KakaoMapsSDK
import SwiftUI

struct KakaoMapView: UIViewRepresentable {
  @Binding var draw: Bool
    
  func makeUIView(context: Self.Context) -> KMViewContainer {
    let view = KMViewContainer()
    view.sizeToFit()
    context.coordinator.createController(view)
    return view
  }

  func updateUIView(_: KMViewContainer, context: Self.Context) {
    if draw {
      Task {
        try? await Task.sleep(for: .seconds(0.5))
        context.coordinator.controller?.prepareEngine()
        context.coordinator.controller?.activateEngine()
      }
    } else {
      context.coordinator.controller?.pauseEngine()
      context.coordinator.controller?.resetEngine()
    }
  }

  func makeCoordinator() -> KakaoMapCoordinator {
    KakaoMapCoordinator()
  }

  // static func dismantleUIView(_: KMViewContainer, coordinator _: KakaoMapCoordinator) {}
    
  class KakaoMapCoordinator: NSObject, MapControllerDelegate {
    var userMapPoint: MapPoint? = MapPoint(longitude: 127.00371914442674, latitude: 37.58360034150261)
    var controller: KMController?
    var first: Bool = true
    var auth: Bool = false
         
    override init() {
      super.init()
    }

    func authenticationSucceeded() {
      auth = true
    }
        
    func createController(_ view: KMViewContainer) {
      controller = KMController(viewContainer: view)
      controller?.delegate = self
    }
        
    func addViews() {
      let mapviewInfo = MapviewInfo(
        viewName: "mapview",
        viewInfoName: "map",
        defaultPosition: userMapPoint
      )
        
      guard let controller else {
        print("controller is nil in addViews")
        return
      }
      controller.addView(mapviewInfo)
    }

    func addViewSucceeded(_: String, viewInfoName _: String) {
      print("✅ View added success")
    }
    
    func addViewFailed(_: String, viewInfoName _: String) {
      print("Failed")
    }

    func containerDidResized(_ size: CGSize) {
      print("containerDidResized")
      let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
      mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
      if first, let userMapPoint {
        let cameraUpdate = CameraUpdate.make(
          target: userMapPoint,
          zoomLevel: 10,
          mapView: mapView!
        )
        mapView?.moveCamera(cameraUpdate)
        first = false
      }
    }
  }
}
