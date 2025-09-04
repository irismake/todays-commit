import SwiftUI

struct GrassMapView: View {
  var showMyMap: Bool
  @EnvironmentObject var mapManager: MapManager
  @EnvironmentObject var grassManager: GrassManager
  @State private var errorMessage: String?
  let gridSize = GlobalStore.shared.gridSize

  var grassData: [GrassData] {
    guard let mapId = mapManager.currentMapId else {
      return []
    }
    if showMyMap {
      return grassManager.cachedMyGrass?.mapId == mapId
        ? grassManager.cachedMyGrass?.grassData ?? []
        : []
    } else {
      return grassManager.cachedTotalGrass?.mapId == mapId
        ? grassManager.cachedTotalGrass?.grassData ?? []
        : []
    }
  }
    
  init(showMyMap: Bool) {
    self.showMyMap = showMyMap
  }

  var body: some View {
    GeometryReader { geometry in
      let mapDatas = mapManager.getMapData()
      if let mapDatas, !mapDatas.isEmpty {
        let activeCoordIds: Set<Int> = Set(mapDatas.map(\.coordId))
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
      } else {
        VStack(spacing: 12) {
          Text("위치 권한이 꺼져 있어요")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)

          Text("설정에서 위치 권한을 켜면\n내 주변 지도를 확인할 수 있어요.")
            .font(.footnote)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .task(id: GrassTaskID(mapId: mapManager.currentMapId, showMyMap: showMyMap)) {
      guard let mapId = mapManager.currentMapId else {
        return
      }
      if showMyMap {
        if grassManager.cachedMyGrass?.mapId != mapId {
          await grassManager.fetchMyGrassData(of: mapId)
        }
      } else {
        if grassManager.cachedTotalGrass?.mapId != mapId {
          await grassManager.fetchTotalGrassData(of: mapId)
        }
      }
    }
  }
}
