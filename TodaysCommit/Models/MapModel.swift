import SwiftUI

struct Coord: Hashable {
  let x: Int
  let y: Int
}

struct CellDataResponse: Decodable {
  let mapLevel: Int
  let mapId: Int
  let cellData: CellData
}

struct CellData: Decodable {
  let coordId: Int
  let zoneCode: Int
}

struct MapDataResponse: Decodable {
  let mapCode: Int
  let mapData: [CellData]
}
