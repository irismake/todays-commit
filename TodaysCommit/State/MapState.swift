import SwiftUI

class CommitViewModel: ObservableObject {
  @Published var selectedGrassCommit: GrassCommit? = nil
  @Published var selectedGrassColor: Color = .lv_0
  @Published var mapZoneCode: Int = 11
  @Published var mapLevel: Int = 1
  @Published var coords: [Int: Coord] = [
    0: Coord(x: 10, y: 5),
    1: Coord(x: 11, y: 10),
    2: Coord(x: 10, y: 6)
  ]

  func resetToDefault() {
    selectedGrassColor = Color.lv_0
    selectedGrassCommit = nil
  }
    
  var selectedZoneName: String {
//    guard let code = selectedZoneCode else {
//      return "잔디를 클릭해주세요."
//    }
    //  return zoneCode[code] ?? "N/A"
    "N/A"
  }

//  var selectedZoneCode: Int? {
//    guard let coord = coords[mapLevel] else {
//      return nil
//    }
  ////    guard let zones = mapData[mapZoneCode] else {
  ////      return nil
  ////    }
//    // return zones.first(where: { $0.coord == coord })?.zoneCode
//  }

  var mapName: String {
    zoneCode[mapZoneCode] ?? "N/A"
  }

  func saveCoord(coord: Coord) {
    if mapLevel == 2 {
      coords.removeValue(forKey: 1)
      coords.removeValue(forKey: 0)

    } else if mapLevel == 1 {
      coords.removeValue(forKey: 0)
    }
    coords[mapLevel] = coord
  }
}
