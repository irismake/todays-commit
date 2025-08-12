import SwiftUI

struct GrassMapView: View {
  var isMine: Bool
  @EnvironmentObject var mapManager: MapManager
  private let grassService = GrassService.shared
    
  @State private var totalGrassData: [GrassData] = []
  @State private var errorMessage: String?
  let gridSize = GlobalStore.shared.gridSize
  let spacing: CGFloat = 4
  let cornerRadius: CGFloat = 3
    
  init(isMine: Bool) {
    self.isMine = isMine
  }
    
  func coordIdToCoord(_ id: Int) -> Coord {
    let x = id % gridSize
    let y = id / gridSize
    return Coord(x: x, y: y)
  }
    
  func coordToCoordId(_ coord: Coord?) -> Int? {
    guard let coord else {
      return nil
    }
    let gridSize = GlobalStore.shared.gridSize
    return coord.y * gridSize + coord.x
  }
    
  var body: some View {
    GeometryReader { geometry in
      let mapDatas = mapManager.getMapData()
      let activeCoords: Set<Coord> = Set((mapDatas ?? []).map { coordIdToCoord($0.coordId) })
      let selectedCoord = mapManager.selectedCoord
      let totalSpacing = CGFloat(gridSize - 1) * spacing
      let cellSize = (min(geometry.size.width, geometry.size.height) - totalSpacing) / CGFloat(gridSize)
            
      let totalCounts = totalGrassData.map(\.commitCount)
      let minCount = totalCounts.min() ?? 0
      let maxCount = totalCounts.max() ?? 0
      let commitStep = maxCount > minCount ? Double(maxCount - minCount) / 4.0 : 1
            
      VStack(spacing: spacing) {
        ForEach(0 ..< gridSize, id: \.self) { y in
          HStack(spacing: spacing) {
            ForEach(0 ..< gridSize, id: \.self) { x in
              let coord = Coord(x: x, y: y)
              let coordId = coordToCoordId(coord)
              let grassData = totalGrassData.first(where: { $0.coordId == coordId })
              let isSelected = selectedCoord == coord
              let grassColor: Color = {
                if mapManager.myCoord == coord {
                  return Color.black
                }
                guard activeCoords.contains(coord) else {
                  return .clear
                }
                                
                if let grassData {
                  let level = Double(grassData.commitCount - minCount)
                  let color: Color
                  switch level {
                  case 0 ..< commitStep: color = .lv_1
                  case commitStep ..< commitStep * 2: color = .lv_2
                  case commitStep * 2 ..< commitStep * 3: color = .lv_3
                  default: color = .lv_4
                  }
                  return color
                } else {
                  return .lv_0
                }
              }()
              RoundedRectangle(cornerRadius: cornerRadius)
                .fill(grassColor)
                .overlay(
                  RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(isSelected ? Color.red : Color.clear, lineWidth: 2)
                )
                .shadow(color: isSelected ? Color.white.opacity(0.7) : Color.clear, radius: 3, x: 0, y: 0)
                .frame(width: cellSize, height: cellSize)
                .scaleEffect(isSelected ? 1.1 : 1.0)
                .animation(.spring(response: 0.3), value: isSelected)
                .onTapGesture {
                  mapManager.updateCell(newCoord: coord)
                }
            }
          }
        }
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .task(id: mapManager.currentMapId) {
      print("task")
      guard let mapId = mapManager.currentMapId else {
        return
      }

      if let cachedData = grassService.getCachedGrassData() {
        if cachedData.mapId == mapId {
          print("cached data")
          totalGrassData = cachedData.grassData
          return
        }
      }
            
      let newGrassData = await grassService.fetchGrassData(of: mapId)

      if mapManager.currentMapId == mapId {
        totalGrassData = newGrassData
      }
    }
  }
}

struct GrassMapView_Previews: PreviewProvider {
  static var previews: some View {
    GrassMapView(isMine: false)
  }
}
