import SwiftUI

final class MapManager: ObservableObject {
  @Published var mapDataLevel0: [Int: [MapData]]?
  @Published var mapDataLevel1: [Int: [MapData]]?
  @Published var mapDataLevel2: [Int: [MapData]]?

  @Published var mapLevel: Int = 1
  var zoomOutDisabled: Bool {
    switch mapLevel {
    case 0:
      return mapDataLevel1?.isEmpty ?? true
    case 1:
      return mapDataLevel2?.isEmpty ?? true
    default:
      return true
    }
  }

  var zoomInDisabled: Bool {
    switch mapLevel {
    case 1:
      return mapDataLevel0?.isEmpty ?? true
    case 2:
      return mapDataLevel1?.isEmpty ?? true
    default:
      return true
    }
  }

  func getMapData() -> [MapData]? {
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
}
