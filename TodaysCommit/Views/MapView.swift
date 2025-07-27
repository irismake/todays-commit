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
    
  class KakaoMapCoordinator: NSObject, MapControllerDelegate, GuiEventDelegate {
    var userMapPoint: MapPoint = .init(longitude: 127.00371914442674, latitude: 37.58360034150261)
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
      createPoi()
      createSpriteGUI()
    }
    
    func addViewFailed(_: String, viewInfoName _: String) {
      print("Failed")
    }
 
    func createPoi() {
      let view = controller?.getView("mapview") as! KakaoMap
      let manager = view.getLabelManager()
      let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 1000)
      let _ = manager.addLabelLayer(option: layerOption)
        
      let iconStyle = PoiIconStyle(symbol: UIImage(named: "my_position"), anchorPoint: CGPoint(x: 0.5, y: 0.5))
      let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
        PerLevelPoiStyle(iconStyle: iconStyle)
      ])
      manager.addPoiStyle(poiStyle)
        
      let layer = manager.getLabelLayer(layerID: "PoiLayer")
      let poiOption = PoiOptions(styleID: "PerLevelStyle")
      poiOption.rank = 0
             
      let poi1 = layer?.addPoi(option: poiOption, at: userMapPoint)
      poi1?.show()
    }
      
    func moveCamera() {
      let mapView: KakaoMap = controller?.getView("mapview") as! KakaoMap
        
      mapView.moveCamera(CameraUpdate.make(cameraPosition: CameraPosition(target: userMapPoint, height: 0, rotation: 0, tilt: 0)))
    }
      
    func createSpriteGUI() {
      let mapView = controller?.getView("mapview") as! KakaoMap
      let guiManager = mapView.getGuiManager()
      let spriteGui = SpriteGui("testSprite")
           
      spriteGui.arrangement = .horizontal
      spriteGui.bgColor = UIColor.clear
      spriteGui.splitLineColor = UIColor.gray

      spriteGui.origin = GuiAlignment(vAlign: .bottom, hAlign: .right)
      spriteGui.position = CGPoint(x: 30, y: 240)
     
      let gpsButton = GuiButton("gps_button")
      gpsButton.image = UIImage(named: "gps")
      spriteGui.addChild(gpsButton)

      let _ = guiManager.spriteGuiLayer.addSpriteGui(spriteGui)
      spriteGui.delegate = self
      spriteGui.show()
    }
       
    func guiDidTapped(_ gui: KakaoMapsSDK.GuiBase, componentName: String) {
      print("Gui: \(gui.name), Component: \(componentName) tapped")
      if componentName == "gps_button" {
        moveCamera()
      }
    }
  }
}
