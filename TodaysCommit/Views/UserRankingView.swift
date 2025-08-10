import SwiftUI

struct UserRankingView: View {
  @EnvironmentObject var mapManager: MapManager
  var body: some View {
    VStack(spacing: 20) {
      HStack {
        Image(systemName: "app.fill")
          .font(.headline)
          .foregroundColor(mapManager.selectedGrassColor)
                
        Text(mapManager.selectedZoneName)
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
                
        Text("총 커밋  0회")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
            
      // if let data = viewModel.selectedGrassCommit, let subZoneCommit = data.subZoneCommit {
      //   let subZoneData = subZoneCommit.map { ($0.zone, $0.commit_count) }
                
//        ForEach(0 ..< subZoneData.count, id: \.self) { index in
//          let (subZoneCode, commitCount) = subZoneData[index]
//          let subZoneName = ""
//          RankingItem(
//            backgroundColor: mapManager.selectedGrassColor.opacity(0.15),
//            user: subZoneName,
//            commitCount: commitCount
//          )
//        }
//      } else {
//        VStack(spacing: 12) {
//          Text(
//            "아직 잔디가 심어지기 전이에요. 😅"
//          )
//          .font(.headline)
//          .foregroundColor(.secondary)
//
//          Text("다른 곳을 눌러 잔디를 확인해보세요!")
//            .font(.subheadline)
//            .foregroundColor(.secondary)
//        }
//        .padding()
//        .frame(maxWidth: .infinity)
//        .background(Color.lv_0.opacity(0.4))
//        .cornerRadius(16)
//      }
    }
  }
}

struct UserRankingView_Previews: PreviewProvider {
  static var previews: some View {
    UserRankingView()
  }
}
