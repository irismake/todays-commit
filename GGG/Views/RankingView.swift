import SwiftUI

struct RankingView: View {
  var isMine: Bool

  let locationData = [
    ("장위 1동", 5, Color.lv_4),
    ("장위 2동", 4, Color.lv_3),
    ("장위 3동", 3, Color.lv_2),
    ("월곡동", 1, Color.lv_1)
  ]
    
  @EnvironmentObject var viewModel: CommitViewModel
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Image(systemName: "app.fill")
          .font(.headline)
          .foregroundColor(viewModel.selectedGrassColor)
                
        Text("성북구")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
                
        Text("총 커밋 \(viewModel.selectedCommitData?.total_commit_count ?? 0)회")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
            
      if let data = viewModel.selectedCommitData {
        let userData = data.rank_users.map { ($0.user_name, $0.commit_count) }
                
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
      } else {
        VStack(spacing: 12) {
          Text(
            "아직 잔디가 안 심어졌어요.😅"
          )
          .font(.headline)
          .foregroundColor(.secondary)

          Text("다른 곳을 눌러 잔디를 확인해보세요!")
            .font(.subheadline)
            .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.lv_0.opacity(0.4))
        .cornerRadius(16)
      }
    }
  }
}

struct RankingView_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = CommitViewModel()
    viewModel.selectedCommitData = CommitData(
      x: 20, y: 16,
      total_commit_count: 172, rank_users: [
        .init(user_name: "irismake", commit_count: 125),
        .init(user_name: "heenano", commit_count: 45),
        .init(user_name: "heySiri", commit_count: 2)
      ]
    )
    viewModel.selectedGrassColor = .lv_2
      
    return Group {
      RankingView(isMine: true).environmentObject(viewModel)
      RankingView(isMine: false).environmentObject(viewModel)
    }
  }
}
