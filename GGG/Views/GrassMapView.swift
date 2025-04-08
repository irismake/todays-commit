import SwiftUI

func loadCommitData(from filename: String) -> [GrassCommit] {
  guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let raw = try? JSONDecoder().decode([GrassCommit].self, from: data)
  else {
    return []
  }

  return raw
}

struct GrassMapView: View {
  @EnvironmentObject var viewModel: CommitViewModel
  let gridSize = 25
  let spacing: CGFloat = 4
  let cornerRadius: CGFloat = 3
  let commitData: [GrassCommit]

  init() {
    commitData = loadCommitData(from: "MockData")
  }

  var body: some View {
    GeometryReader { geometry in
      let totalSpacing = CGFloat(gridSize - 1) * spacing
      let cellSize = (min(geometry.size.width, geometry.size.height) - totalSpacing) / CGFloat(gridSize)

      let counts = commitData.map(\.total_commit_count)
      let minCount = counts.min() ?? 0
      let maxCount = counts.max() ?? 0
      let commitStep = maxCount > minCount ? Double(maxCount - minCount) / 4.0 : 1

      VStack(spacing: spacing) {
        ForEach(0 ..< gridSize, id: \.self) { y in
          HStack(spacing: spacing) {
            ForEach(0 ..< gridSize, id: \.self) { x in
              let coord = Coord(x: x, y: y)
              let grassCommitData = commitData.first(where: { $0.x == x && $0.y == y })

              let (grassColor, zone): (Color, String) = {
                guard let match = seoul.first(where: { $0.coord == coord }) else {
                  return (.clear, "")
                }
                    
                let zoneName = seoulZoneCode[match.zoneCode] ?? ""
                if let grassCommitData {
                  let level = Double(grassCommitData.total_commit_count - minCount)
                  let color: Color
                  switch level {
                  case 0 ..< commitStep: color = .lv_1
                  case commitStep ..< commitStep * 2: color = .lv_2
                  case commitStep * 2 ..< commitStep * 3: color = .lv_3
                  default: color = .lv_4
                  }
                  return (color, zoneName)
                } else {
                  return (.lv_0, zoneName)
                }
              }()
                
              RoundedRectangle(cornerRadius: cornerRadius)
                .fill(grassColor)
                .frame(width: cellSize, height: cellSize)
                .onTapGesture {
                  viewModel.selectedGrassCommit = grassCommitData
                  viewModel.selectedGrassColor = grassColor
                  viewModel.selectedZone = zone
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
    return GrassMapView()
      .environmentObject(viewModel)
  }
}
