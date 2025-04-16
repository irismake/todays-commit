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
  @StateObject private var mailHandler = MailHandler()
      
  let gridSize = 25
  let spacing: CGFloat = 4
  let cornerRadius: CGFloat = 3
  var commitData: [GrassCommit] = []
    
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

      if let mapCoord = mapData[currentZoneCode] {
        VStack(spacing: spacing) {
          ForEach(0 ..< gridSize, id: \.self) { y in
            HStack(spacing: spacing) {
              ForEach(0 ..< gridSize, id: \.self) { x in
                let coord = Coord(x: x, y: y)
                let grassCommitData = commitData.first(where: { $0.x == x && $0.y == y })
                                
                let (grassColor, zoneCode): (Color, Int?) = {
                  guard let match = mapCoord.first(where: { $0.coord == coord }) else {
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
      } else {
        ZStack {
          RoundedRectangle(cornerRadius: 20)
            .fill(Color.lv_0.opacity(0.2))
            .shadow(color: Color.black.opacity(0.04), radius: 15, x: 0, y: 2)
                    
          VStack(spacing: 12) {
            Image(systemName: "apple.meditate")
              .font(.system(size: 30))
              .foregroundColor(.secondary.opacity(0.7))
              .padding(.bottom, 4)
                        
            Text("아직 지도가 준비되지 않았어요.")
              .font(.headline)
              .foregroundColor(.secondary)
                        
            Button(action: {
              let mailData = MailData(
                subject: "[\(viewModel.currentZoneName)] 지도 추가 요청",
                content: "지역 코드 \(viewModel.currentZoneCode)에 해당하는 \(viewModel.currentZoneName)의 지도 추가를 요청합니다."
              )
              mailHandler.saveMailData(for: mailData)
              mailHandler.showMailOptions()
            }) {
              HStack(spacing: 6) {
                Image(systemName: "paperplane.fill")
                  .font(.system(size: 14))
                Text("지도 요청하기")
                  .font(.system(size: 14, weight: .medium))
              }
              .foregroundColor(.white)
              .padding(.horizontal, 18)
              .padding(.vertical, 8)
              .background(Color.blue.opacity(0.8))
              .cornerRadius(8)
            }
            .padding(.top, 20)
          }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    }
    .aspectRatio(1, contentMode: .fit)
    .sheet(isPresented: $mailHandler.showDefaultMailView) {
      MailView(mailHandler: mailHandler)
    }
  }
}

struct GrassMapView_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = CommitViewModel()
    return GrassMapView(isMine: false)
      .environmentObject(viewModel)
  }
}
