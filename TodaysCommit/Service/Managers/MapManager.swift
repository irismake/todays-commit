import Combine
import SwiftUI

final class MapManager: ObservableObject {
  @Published var currentMapData: [Int: [CellData]]?
  @Published var currentMapId: Int?
  @Published var mapLevel: Int = 1
  @Published var myCells: [CellDataResponse] = []
  @Published var selectedCell: CellData?
  @Published var selectedCoord: Coord?
  @Published var selectedGrassColor: Color = .lv_0

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

  var myCoord: Coord? {
    if myCells[mapLevel].mapId == currentMapId {
      return coordIdToCoord(myCells[mapLevel].cellData.coordId)
          
    } else {
      return nil
    }
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
      // 줌 인 버튼 색 비활성화 & 맵 데이터 불러올때 다시 활성화로 변경
      return
    }
    currentMapId = mapId

    if zoomingIn {
      mapLevel -= 1
    } else {
      mapLevel += 1
    }
      
    guard let coordId = selectedCell?.coordId else {
      return
    }
    let coord = coordIdToCoord(coordId)
    updateCell(newCoord: coord)
  }
    
  private var cancellables = Set<AnyCancellable>()
    
  init() {
    $mapLevel
      .removeDuplicates()
      .sink { _ in
        Task { [weak self] in
          guard let self else {
            return
          }
          guard let currentMapId else {
            return
          }
          await self.fetchMapData(of: currentMapId)
          await self.resetSelectedCell()
        }
      }
      .store(in: &cancellables)
  }
    
  @MainActor
  func resetSelectedCell() {
    selectedCoord = nil
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

  func updateCell(newCoord: Coord) {
    selectedCoord = newCoord
    let coordId = coordToCoordId(newCoord)
      
    selectedCell = currentMapData?
      .values
      .flatMap { $0 }
      .first { $0.coordId == coordId }
  }

  @MainActor
  func fetchMapData(of mapId: Int) async {
    do {
      let overlayVC = Overlay.show(LoadingView())
      defer { overlayVC.dismiss(animated: true) }
      let mapDataResponse = try await MapAPI.getMap(mapId)
      let mapCode = mapDataResponse.mapCode
      let mapData = mapDataResponse.mapData
      currentMapData = [mapCode: mapData]
    } catch {
      print("❌ fetchMapData : \(error.localizedDescription)")
    }
  }
    
  func coordIdToCoord(_ id: Int) -> Coord {
    let gridSize = GlobalStore.shared.gridSize
    let x = id % gridSize
    let y = id / gridSize
    return Coord(x: x, y: y)
  }
      
  func coordToCoordId(_ coord: Coord) -> Int {
    let gridSize = GlobalStore.shared.gridSize
    return coord.y * gridSize + coord.x
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
