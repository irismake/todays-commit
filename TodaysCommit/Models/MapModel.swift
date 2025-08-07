import SwiftUI

struct CellDataResponse: Decodable {
  let pnu: Int
  let maps: [CellData]
}

struct CellData: Decodable {
  let mapLevel: Int
  let mapId: Int
  let coordId: Int
}

struct MapDataResponse: Decodable {
  let mapCode: Int
  let mapData: [MapData]
}

struct MapData: Decodable {
  let coordId: Int
  let zoneCode: Int
}
