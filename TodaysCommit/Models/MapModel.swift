struct Coord: Hashable {
  let x: Int
  let y: Int
}

struct CellDataResponse: Decodable {
  let mapLevel: Int
  let mapId: Int
  let cellData: CellData
}

struct CellData: Decodable, Equatable {
  let coordId: Int
  let zoneCode: Int
}

struct MapDataResponse: Decodable {
  let mapCode: Int
  let mapData: [CellData]
}

struct MapData: Decodable {
  let mapId: Int
  let mapLevel: Int
}
