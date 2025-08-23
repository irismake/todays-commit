import SwiftUI

struct GrassMapView: View {
  var showMyMap: Bool
  @EnvironmentObject var mapManager: MapManager
  private let grassService = GrassService.shared
  @State private var grassData: [GrassData] = []
  @State private var errorMessage: String?
  let gridSize = GlobalStore.shared.gridSize

  init(showMyMap: Bool) {
    self.showMyMap = showMyMap
  }

  var body: some View {
    GeometryReader { geometry in
      let mapDatas = mapManager.getMapData()
      let activeCoordIds: Set<Int> = Set((mapDatas ?? []).map(\.coordId))
      let selectedCell = mapManager.selectedCell?.coordId
        
      let totalCounts = grassData.map(\.commitCount)
      let minCount = totalCounts.min() ?? 0
      let maxCount = totalCounts.max() ?? 0
      let commitStep = maxCount > minCount ? Double(maxCount - minCount) / 4.0 : 1

      let availableSize = min(geometry.size.width, geometry.size.height)
      let baseCellSize = availableSize / CGFloat(gridSize + 1)
      let spacing = baseCellSize * 0.25
      let totalSpacing = CGFloat(gridSize - 1) * spacing
      let cellSize = (availableSize - totalSpacing) / CGFloat(gridSize)
      let cornerRadius = cellSize * 0.2
      let strokeWidth = cellSize * 0.15

      let totalGridSize = CGFloat(gridSize) * cellSize + totalSpacing
      let centerOffsetX = (geometry.size.width - totalGridSize) / 2
      let centerOffsetY = (geometry.size.height - totalGridSize) / 2

      ZStack {
        ForEach(0 ..< gridSize * gridSize, id: \.self) { coordId in
          let y = coordId / gridSize
          let x = coordId % gridSize
          let grassData = grassData.first(where: { $0.coordId == coordId })
          let isSelected = selectedCell == coordId
          let grassColor: Color = {
            if mapManager.gpsCoordId == coordId {
              return .primary
            }
            guard activeCoordIds.contains(coordId) else {
              return .clear
            }
            if let grassData {
              let level = Double(grassData.commitCount - minCount)
              let color: Color
              switch level {
              case 0 ..< commitStep:
                color = .lv_1
              case commitStep ..< commitStep * 2:
                color = .lv_2
              case commitStep * 2 ..< commitStep * 3:
                color = .lv_3
              default:
                color = .lv_4
              }
              return color
            } else {
              return .lv_0
            }
          }()

          let positionX = centerOffsetX + CGFloat(x) * (cellSize + spacing)
          let positionY = centerOffsetY + CGFloat(y) * (cellSize + spacing)

          RoundedRectangle(cornerRadius: cornerRadius)
            .fill(grassColor)
            .overlay(
              RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(isSelected ? Color.primary : .clear, lineWidth: strokeWidth)
            )
            .scaleEffect(isSelected ? 1.25 : 1.0)
            .zIndex(isSelected ? 1 : 0)
            .animation(.spring(response: 0.3), value: isSelected)
            .frame(width: cellSize, height: cellSize)
            .position(x: positionX + cellSize / 2, y: positionY + cellSize / 2)
            .onTapGesture {
              Task {
                await mapManager.updateCell(newCoordId: coordId, grassColor: grassColor)
              }
            }
        }
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
    .aspectRatio(1, contentMode: .fit)
    .task(id: GrassTaskID(mapId: mapManager.currentMapId, showMyMap: showMyMap)) {
      print("task")
      guard let mapId = mapManager.currentMapId else {
        return
      }
            
      if showMyMap {
        if let cachedMyData = grassService.getMyCachedGrass() {
          if cachedMyData.mapId == mapId {
            print("cached My data")
            grassData = cachedMyData.grassData
            return
          }
        }
        let myGrassData = await grassService.fetchMyGrassData(of: mapId)
        if mapManager.currentMapId == mapId {
          grassData = myGrassData
        }
      } else {
        if let cachedTotalData = grassService.getTotalCachedGrass() {
          if cachedTotalData.mapId == mapId {
            print("cached Total data")
            grassData = cachedTotalData.grassData
            return
          }
        }
        let totalGrassData = await grassService.fetchTotalGrassData(of: mapId)
        if mapManager.currentMapId == mapId {
          grassData = totalGrassData
        }
      }
    }
  }
}

struct GrassMapView_Previews: PreviewProvider {
  static var previews: some View {
    GrassMapView(showMyMap: false)
  }
}
