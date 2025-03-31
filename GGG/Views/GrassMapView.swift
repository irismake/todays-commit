import SwiftUI

func loadCommitData(from filename: String) -> [Coord: CommitData] {
  guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
        let data = try? Data(contentsOf: url),
        let raw = try? JSONDecoder().decode([CommitData].self, from: data)
  else {
    return [:]
  }

  var map: [Coord: CommitData] = [:]
  for item in raw {
    let coord = Coord(x: item.x, y: item.y)
    map[coord] = item
  }

  return map
}

struct GrassMapView: View {
  @EnvironmentObject var viewModel: CommitViewModel
  let gridSize = 25
  let spacing: CGFloat = 4
  let cornerRadius: CGFloat = 3
  let commitData: [Coord: CommitData]

  init() {
    commitData = loadCommitData(from: "MockData")
  }

  var body: some View {
    GeometryReader { geometry in
      let totalSpacing = CGFloat(gridSize - 1) * spacing
      let cellSize = (min(geometry.size.width, geometry.size.height) - totalSpacing) / CGFloat(gridSize)

      let counts = commitData.values.map(\.total_commit_count)
      let minCount = counts.min() ?? 0
      let maxCount = counts.max() ?? 0
      let step = maxCount > minCount ? Double(maxCount - minCount) / 4.0 : 1

      VStack(spacing: spacing) {
        ForEach(0 ..< gridSize, id: \.self) { y in
          HStack(spacing: spacing) {
            ForEach(0 ..< gridSize, id: \.self) { x in
              let coord = Coord(x: x, y: y)

              let grassColor: Color = {
                guard seoul.contains(coord) else {
                  return Color.clear
                }

                if let data = commitData[coord] {
                  let level = Double(data.total_commit_count - minCount)
                  switch level {
                  case 0 ..< step: return Color.lv_1
                  case step ..< step * 2: return Color.lv_2
                  case step * 2 ..< step * 3: return Color.lv_3
                  default: return Color.lv_4
                  }
                }
                return Color.lv_0
              }()

              RoundedRectangle(cornerRadius: cornerRadius)
                .fill(grassColor)
                .frame(width: cellSize, height: cellSize)
                .onTapGesture {
                  viewModel.selectedCommitData = commitData[coord]
                  viewModel.selectedGrassColor = grassColor
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
    GrassMapView()
      .padding()
  }
}
