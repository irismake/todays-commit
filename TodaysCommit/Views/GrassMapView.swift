import SwiftUI

func loadCommitData(from filename: String, isMine: Bool) -> [GrassCommit] {
  guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
        let data = try? Data(contentsOf: url)
  else {
    return []
  }

  if isMine {
    if let raw = try? JSONDecoder().decode([UserGrassCommit].self, from: data) {
      return raw.map { .user($0) }
    }
  } else {
    if let raw = try? JSONDecoder().decode([TotalGrassCommit].self, from: data) {
      return raw.map { .total($0) }
    }
  }

  return []
}

struct GrassMapView: View {
  var isMine: Bool
  @EnvironmentObject var mapManager: MapManager
  @StateObject private var mailHandler = MailHandler()
  let gridSize = GlobalStore.shared.gridSize
  let spacing: CGFloat = 4
  let cornerRadius: CGFloat = 3
  var commitData: [GrassCommit] = []
    
  init(isMine: Bool) {
    self.isMine = isMine
    commitData = loadCommitData(from: isMine ? "UserMockData" : "TotalMockData", isMine: isMine)
  }
    
  func coordIdToCoord(_ id: Int) -> Coord {
    let x = id % gridSize
    let y = id / gridSize
    return Coord(x: x, y: y)
  }

  var body: some View {
    GeometryReader { geometry in
      let totalSpacing = CGFloat(gridSize - 1) * spacing
      let cellSize = (min(geometry.size.width, geometry.size.height) - totalSpacing) / CGFloat(gridSize)
      let counts = commitData.map(\.totalCommitCount)
      let minCount = counts.min() ?? 0
      let maxCount = counts.max() ?? 0
      let commitStep = maxCount > minCount ? Double(maxCount - minCount) / 4.0 : 1
          
      let mapDatas = mapManager.getMapData()
      let activeCoords: Set<Coord> = Set((mapDatas ?? []).map { coordIdToCoord($0.coordId) })
      let selectedCoord = mapManager.selectedCoord
      VStack(spacing: spacing) {
        ForEach(0 ..< gridSize, id: \.self) { y in
          HStack(spacing: spacing) {
            ForEach(0 ..< gridSize, id: \.self) { x in
              let coord = Coord(x: x, y: y)
              let grassCommitData = commitData.first(where: { $0.x == x && $0.y == y })
              let isSelected = selectedCoord == coord
              let grassColor: Color = {
                if mapManager.myCoord == coord {
                  return Color.black
                }
                guard activeCoords.contains(coord) else {
                  return .clear
                }

                if let grassCommitData {
                  let level = Double(grassCommitData.totalCommitCount - minCount)
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
  }
}

struct GrassMapView_Previews: PreviewProvider {
  static var previews: some View {
    GrassMapView(isMine: false)
  }
}
