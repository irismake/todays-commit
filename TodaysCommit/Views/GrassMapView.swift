import SwiftUI

struct GrassMapView: View {
  var showMyMap: Bool
  @EnvironmentObject var mapManager: MapManager
  private let grassService = GrassService.shared
    
  @State private var grassData: [GrassData] = []
  @State private var errorMessage: String?
  let gridSize = GlobalStore.shared.gridSize
  let spacing: CGFloat = 4
  let cornerRadius: CGFloat = 3
    
  init(showMyMap: Bool) {
    self.showMyMap = showMyMap
  }
    
  var body: some View {
    GeometryReader { geometry in
      let mapDatas = mapManager.getMapData()
      let activeCoordIds: Set<Int> = Set((mapDatas ?? []).map(\.coordId))
      let selectedCell = mapManager.selectedCell?.coordId
      let totalSpacing = CGFloat(gridSize - 1) * spacing
      let cellSize = (min(geometry.size.width, geometry.size.height) - totalSpacing) / CGFloat(gridSize)
            
      let totalCounts = grassData.map(\.commitCount)
      let minCount = totalCounts.min() ?? 0
      let maxCount = totalCounts.max() ?? 0
      let commitStep = maxCount > minCount ? Double(maxCount - minCount) / 4.0 : 1
            
      VStack(spacing: spacing) {
        ForEach(0 ..< gridSize, id: \.self) { y in
          HStack(spacing: spacing) {
            ForEach(0 ..< gridSize, id: \.self) { x in
              let coordId = y * gridSize + x
           
              let grassData = grassData.first(where: { $0.coordId == coordId })
              let isSelected = selectedCell == coordId
              let grassColor: Color = {
                if mapManager.gpsCoordId == coordId {
                  return Color.black
                }
                guard activeCoordIds.contains(coordId) else {
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
                  Task {
                    await mapManager.updateCell(newCoordId: coordId, grassColor: grassColor)
                  }
                }
            }
          }
        }
      }
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
