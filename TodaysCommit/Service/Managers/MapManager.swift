import Combine
import SwiftUI

final class MapManager: ObservableObject {
  @Published var currentMapData: [Int: [CellData]]?
  @Published var currentMapId: Int?
  @Published var mapLevel: Int = 1
  @Published var gpsCells: [CellDataResponse] = []
  @Published var selectedCell: CellData?
  @Published var selectedGrassColor: Color = .lv_0
  private let placeService = PlaceService.shared

  var mapName: String {
    guard let mapCode = getMapCode() else {
      return "오늘의 커밋"
    }
    return nominationData[mapCode] ?? "N/A"
  }

  var selectedZoneName: String {
    guard let zoneCode = selectedCell?.zoneCode else {
      return "잔디를 클릭해주세요."
    }
    return nominationData[zoneCode] ?? "잔디를 클릭해주세요."
  }

  var gpsCoordId: Int? {
    guard let currentCell = gpsCells.first(where: { $0.mapLevel == self.mapLevel }),
          currentCell.mapId == currentMapId
    else {
      return nil
    }
    return currentCell.cellData.coordId
  }
    
  var zoomOutDisabled: Bool {
    !(0 ... 1).contains(mapLevel)
  }

  var zoomInDisabled: Bool {
    !(1 ... 2).contains(mapLevel)
  }
      
  func changeMapLevel(_ zoomingIn: Bool) {
    var mapId: Int?

    if zoomingIn {
      guard let subZoneCode = selectedCell?.zoneCode else {
        Overlay.show(Notification())
        return
      }
      mapId = mapCodeId[subZoneCode]?.mapId
          
    } else {
      guard let mapCode = getMapCode() else {
        return
      }
      let upperZoneCode = getUpperZoneCode(from: mapCode)
      mapId = mapCodeId[upperZoneCode]?.mapId
    }
        
    guard let mapId else {
      Overlay.show(
        RequestOverlay(requestMapName: selectedZoneName) {
          let overlayVC = Overlay.show(ToastView(message: "요청이 완료되었습니다."))
          Task { @MainActor in
            defer { overlayVC.dismiss(animated: true) }
            try await Task.sleep(nanoseconds: 3_000_000_000)
          }
        }
      )
      return
    }
    currentMapId = mapId

    if zoomingIn {
      mapLevel -= 1
    } else {
      mapLevel += 1
    }
  }
    
  private var cancellables = Set<AnyCancellable>()
    
  init() {
    $mapLevel
      .removeDuplicates()
      .sink { [weak self] _ in
        guard let self else {
          return
        }

        // UI 상태 업데이트는 메인에서
        Task { @MainActor in
          self.resetSelectedCell()
        }

        // 비동기 fetch는 백그라운드에서
        Task { [weak self] in
          guard let self, let currentMapId = self.currentMapId else {
            return
          }
          await self.fetchMapData(of: currentMapId)
        }
      }
      .store(in: &cancellables)
  }
    
  @MainActor
  func resetSelectedCell() {
    selectedCell = nil
  }

  func getMapCode() -> Int? {
    currentMapData?.keys.first
  }
    
  func getMapData() -> [CellData]? {
    currentMapData?
      .values
      .flatMap { $0 }
  }
    
  @MainActor
  func updateCell(newCoordId: Int?, grassColor: Color) async {
    let overlayVC = Overlay.show(LoadingView())
    defer { overlayVC.dismiss(animated: true) }
    selectedGrassColor = grassColor
    guard let newCoordId else {
      // 지도내의 gpsCoordId 가 없을때
      if let currentCell = gpsCells.first(where: { $0.mapLevel == self.mapLevel }) {
        let mapId = currentCell.mapId
        Task {
          @MainActor in
          await fetchMapData(of: mapId)
        
          await placeService.getMainPlace(mapId: mapId, coordId: currentCell.cellData.coordId, sort: "popular")
            
          selectedCell = currentMapData?
            .values
            .flatMap { $0 }
            .first { $0.coordId == currentCell.cellData.coordId }
        }
      }
      return
    }
    guard let currentMapId else {
      return
    }
        
    await placeService.getMainPlace(mapId: currentMapId, coordId: newCoordId, sort: "popular")
      
    selectedCell = currentMapData?
      .values
      .flatMap { $0 }
      .first { $0.coordId == newCoordId }
  }

  @MainActor
  func fetchMapData(of mapId: Int) async {
    let overlayVC = Overlay.show(LoadingView())
    defer { overlayVC.dismiss(animated: true) }
    do {
      async let mapRes = MapAPI.getMap(mapId)
      let mapDataResponse = try await mapRes
      let mapCode = mapDataResponse.mapCode
      let mapData = mapDataResponse.mapData
      currentMapData = [mapCode: mapData]
      currentMapId = mapId
    } catch {
      print("❌ fetchMapData : \(error.localizedDescription)")
    }
  }
    
  func getUpperZoneCode(from code: Int) -> Int {
    let codeStr = String(code)
    if codeStr.count == 2 {
      return 410
    } else {
      let upperCodeStr = codeStr.dropLast(3)
      guard let upperCode = Int(upperCodeStr) else {
        // 변환 실패 시 기본값 지정
        return 0
      }
      return upperCode
    }
  }
}
