import SwiftUI

struct TotalRankingView: View {
  @EnvironmentObject var viewModel: CommitViewModel
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Image(systemName: "app.fill")
          .font(.headline)
          .foregroundColor(viewModel.selectedGrassColor)
                
        Text(viewModel.selectedZone)
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
                
        Text("총 커밋 \(viewModel.selectedGrassCommit?.totalCommitCount ?? 0)회")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
            
      if let data = viewModel.selectedGrassCommit, let rankUsers = data.rankUsers {
        let userData = rankUsers.map { ($0.user_name, $0.commit_count) }
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
        
      } else {
        VStack(spacing: 12) {
          Text(
            "아직 잔디가 심어지기 전이에요. 😅"
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

struct TotalRankingView_Previews: PreviewProvider {
  static var previews: some View {
    let viewModel = CommitViewModel()
    viewModel.selectedGrassCommit = .total(TotalGrassCommit(
      x: 20, y: 16,
      total_commit_count: 172, rank_users: [
        .init(user_name: "irismake", commit_count: 125),
        .init(user_name: "heenano", commit_count: 45),
        .init(user_name: "heySiri", commit_count: 2)
      ]
    ))
    viewModel.selectedGrassColor = .lv_2
      
    return
      TotalRankingView().environmentObject(viewModel)
  }
}
