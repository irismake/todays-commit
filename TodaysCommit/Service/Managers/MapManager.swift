import Combine
import SwiftUI

final class MapManager: ObservableObject {
  @Published var mapDataLevel0: [Int: [CellData]]?
  @Published var mapDataLevel1: [Int: [CellData]]?
  @Published var mapDataLevel2: [Int: [CellData]]?
  @Published var mapLevel: Int = 1
  @Published var mapName: String = "오늘의 커밋"
  @Published var cellDict: [Int: CellData] = [:]
  @Published var selectedCell: CellData?
  @Published var selectedCoord: Coord = .init(x: 12, y: 12)
  @Published var selectedGrassColor: Color = .lv_0

  var selectedZoneName: String {
    guard let zoneCode = selectedCell?.zoneCode else {
      return "잔디를 클릭해주세요."
    }
    return nominationData[zoneCode] ?? "잔디를 클릭해주세요."
  }
 
  private var cancellables = Set<AnyCancellable>()

  init() {
    print("초기화")
    $mapLevel
      .removeDuplicates()
      .sink { newLevel in
        print("📍 mapLevel 변경 감지됨: \(newLevel)")
        self.updateMapData(forLevel: newLevel)
      }
      .store(in: &cancellables)
  }
    
  func getMapData() -> [CellData]? {
    switch mapLevel {
    case 0:
      return mapDataLevel0?.values.flatMap { $0 }
    case 1:
      return mapDataLevel1?.values.flatMap { $0 }
    case 2:
      return mapDataLevel2?.values.flatMap { $0 }
    default:
      return nil
    }
  }

  func getMapCode(ofLevel level: Int) -> Int? {
    switch level {
    case 0: return mapDataLevel0?.keys.first
    case 1: return mapDataLevel1?.keys.first
    case 2: return mapDataLevel2?.keys.first
    default: return nil
    }
  }

  func updateMapData(forLevel level: Int) {
    let mapCode = getMapCode(ofLevel: level)
    updateMapName(for: mapCode ?? 11)
    initCellData(level: level)
  }

  func updateMapName(for mapCode: Int) {
    mapName = nominationData[mapCode] ?? "N/A"
  }

  func initCellData(level: Int) {
    guard let cell = cellDict[level] else {
      return
    }
    selectedCell = cell
    selectedCoord = coordIdToCoord(selectedCell?.coordId ?? 0)
  }
    
  func updateCellData(newCoord: Coord) {
    selectedCoord = newCoord
    let coordId = coordToCoordId(newCoord)

    let dict: [Int: [CellData]]?
    switch mapLevel {
    case 0: dict = mapDataLevel0
    case 1: dict = mapDataLevel1
    case 2: dict = mapDataLevel2
    default: dict = nil
    }

    selectedCell = dict?
      .values
      .flatMap { $0 }
      .first { $0.coordId == coordId }
  }

  @MainActor
  func fetchInitMapData(_ currentLocation: Location) async {
    do {
      let pnuResponse = try await LocationAPI.getPnu(lat: currentLocation.lat, lon: currentLocation.lon)
      let cells = try await MapAPI.getCell(pnuResponse.pnu)

      for cell in cells {
        do {
          let mapId = cell.mapId
          let mapLevel = cell.mapLevel
          let cellData = cell.cellData
          let mapDataResponse = try await MapAPI.getMap(mapId)
          let mapCode = mapDataResponse.mapCode
          let mapData = mapDataResponse.mapData
          let dict = [mapCode: mapData]
                  
          switch mapLevel {
          case 0:
            mapDataLevel0 = dict
            cellDict[0] = cellData
          case 1:
            mapDataLevel1 = dict
            cellDict[1] = cellData
          default:
            mapDataLevel2 = dict
            cellDict[2] = cellData
          }
          print("데이터 저장")
                     
        } catch {
          print("❌ loadInitialData 에서 에러: \(error)")
        }
      }
      updateMapData(forLevel: 1)
    } catch {
      print("❌ 초기 데이터 로드 실패: \(error.localizedDescription)")
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
}
