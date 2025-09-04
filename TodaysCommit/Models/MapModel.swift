struct CellResponse: Decodable {
  let mapLevel: Int
  let mapId: Int
  let cellData: CellData
}

struct CellData: Decodable, Equatable {
  let coordId: Int
  let zoneCode: Int
}

struct MapResponse: Decodable {
  let mapCode: Int
  let mapData: [CellData]
}

struct MapBase: Decodable {
  let mapId: Int
  let mapLevel: Int
}

enum MapIdResult {
  case success(Int)
  case noSelectedCell
  case noNextMapId
}
