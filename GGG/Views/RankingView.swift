import SwiftUI

struct RankingView: View {
  var isMine: Bool
  var grassColor: Color

  let userData = [
    ("irismake", 125),
    ("heenano", 45),
    ("heySiri", 2)
  ]

  let locationData = [
    ("장위 1동", 5, Color.lv_4),
    ("장위 2동", 4, Color.lv_3),
    ("장위 3동", 3, Color.lv_2),
    ("월곡동", 1, Color.lv_1)
  ]

  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Image(systemName: "app.fill")
          .font(.headline)
          .foregroundColor(grassColor)

        Text("성북구")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)

        Text("총 커밋 172회")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)

      if isMine {
        ForEach(0 ..< locationData.count, id: \.self) { index in
          let (location, commit, color) = locationData[index]
          RankingItem(
            backgroundColor: color.opacity(0.15),
            user: location,
            commitCount: commit
          )
        }
      } else {
        let bgColors: [Color] = [
          Color.yellow.opacity(0.1),
          Color.gray.opacity(0.1),
          Color.brown.opacity(0.1)
        ]

        ForEach(0 ..< userData.count, id: \.self) { index in
          let (user, commit) = userData[index]
          RankingItem(
            backgroundColor: bgColors[index % bgColors.count],
            user: user,
            commitCount: commit
          )
        }
      }
    }
  }
}

struct RankingView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RankingView(isMine: true, grassColor: .lv_2)
      RankingView(isMine: false, grassColor: Color.green)
    }
  }
}
