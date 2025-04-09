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
  @EnvironmentObject var viewModel: CommitViewModel
  let gridSize = 25
  let spacing: CGFloat = 4
  let cornerRadius: CGFloat = 3
  var commitData: [GrassCommit] = [
    .total(TotalGrassCommit(x: 1, y: 2, total_commit_count: 100, rank_users: [])),
    .user(UserGrassCommit(x: 3, y: 4, total_commit_count: 50, sub_zone_commit: []))
  ]

  init(isMine: Bool) {
    self.isMine = isMine
    commitData = loadCommitData(from: isMine ? "UserMockData" : "TotalMockData", isMine: isMine)
  }

  var body: some View {
    GeometryReader { geometry in
      let totalSpacing = CGFloat(gridSize - 1) * spacing
      let cellSize = (min(geometry.size.width, geometry.size.height) - totalSpacing) / CGFloat(gridSize)
      let counts = commitData.map(\.totalCommitCount)
      let minCount = counts.min() ?? 0
      let maxCount = counts.max() ?? 0
      let commitStep = maxCount > minCount ? Double(maxCount - minCount) / 4.0 : 1
      let currentZoneCode = viewModel.currentZoneCode
        
      VStack(spacing: spacing) {
        ForEach(0 ..< gridSize, id: \.self) { y in
          HStack(spacing: spacing) {
            ForEach(0 ..< gridSize, id: \.self) { x in
              let coord = Coord(x: x, y: y)
              let grassCommitData = commitData.first(where: { $0.x == x && $0.y == y })

              let (grassColor, zoneCode): (Color, Int?) = {
                guard let mapCoord = mapData[currentZoneCode],
                      let match = mapCoord.first(where: { $0.coord == coord })
                else {
                  return (.clear, nil)
                }
                let code = match.zoneCode
                if let grassCommitData {
                  let level = Double(grassCommitData.totalCommitCount - minCount)
                  let color: Color
                  switch level {
                  case 0 ..< commitStep: color = .lv_1
                  case commitStep ..< commitStep * 2: color = .lv_2
                  case commitStep * 2 ..< commitStep * 3: color = .lv_3
                  default: color = .lv_4
                  }
                  return (color, code)
                } else {
                  return (.lv_0, code)
                }
              }()
                
              RoundedRectangle(cornerRadius: cornerRadius)
                .fill(grassColor)
                .frame(width: cellSize, height: cellSize)
                .onTapGesture {
                  viewModel.selectedGrassCommit = grassCommitData
                  viewModel.selectedGrassColor = grassColor
                  viewModel.selectedZoneCode = zoneCode
                }
            }
          }
        }
      }
      .frame(width: geometry.size.width, height: geometry.size.height)
    }
    .aspectRatio(1, contentMode: .fit)
  }
}

struct GrassMapView_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = CommitViewModel()
    return GrassMapView(isMine: false)
      .environmentObject(viewModel)
  }
}
