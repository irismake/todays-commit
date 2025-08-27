import SwiftUI

struct UserView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var myCommits: [CommitData] = []
  let placeColor: [Color] = [.yellow, .gray, .brown]

  let colorMap: [Color: String] = [
    .yellow: "gold",
    .gray: "silver",
    .brown: "bronze"
  ]

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.primary)
        }
        Spacer()
        Text("마이페이지")
          .font(.subheadline)
          .foregroundColor(.primary)
          .fontWeight(.semibold)
              
        Spacer()
      }
      .padding()
          
      ScrollView {
        VStack {
          VStack {
            ProviderBadge(provider: "kakao")
            Text("김가희")
              .font(.title)
              .foregroundColor(.primary)
              .fontWeight(.bold)
              .padding()
          }
          .padding(.vertical)
                  
          HStack {
            Text("커밋 히스토리")
              .font(.subheadline)
              .fontWeight(.semibold)
              .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
              .font(.system(size: 12, weight: .semibold))
              .foregroundColor(.gray.opacity(0.6))
          }
          .padding(.top)
          .padding(.horizontal)
                  
          if !myCommits.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(myCommits, id: \.id) { commit in
                  CommitItem(onTap: {}, commitData: commit)
                    .frame(width: 240)
                }
              }
              .padding()
            }
          } else {
            // 커밋 내역 없을때 보여주기뷰
          }
            
          HStack {
            Text("나의 랭킹 장소")
              .font(.subheadline)
              .fontWeight(.semibold)
              .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
              .font(.system(size: 12, weight: .semibold))
              .foregroundColor(.gray.opacity(0.6))
          }
          .padding(.top)
          .padding(.horizontal)
                  
          ScrollView(.horizontal, showsIndicators: false) {
            HStack {
              ForEach(placeColor, id: \.self) { color in
                if let imageName = colorMap[color] {
                  ZStack(alignment: .topLeading) {
                    PlaceItem(onTap: {}, placeName: "파머스 카페", distance: "20m", commitCount: 3, grassColor: color)
                      .frame(width: 240)
                                      
                    Image(imageName)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 22, height: 22)
                      .offset(x: 10, y: -10)
                  }
                }
              }
            }
            .padding()
          }
        }
      }
    }
    .onAppear {
      Task {
        let overlayVC = Overlay.show(LoadingView())
        defer { overlayVC.dismiss(animated: true) }
        do {
          let res = try await CommitAPI.getMyCommit(of: 10)
          myCommits = res.commits
        } catch {
          print("❌ getMyCommit: \(error.localizedDescription)")
        }
      }
    }
  }
}

struct UserView_Previews: PreviewProvider {
  static var previews: some View {
    UserView()
  }
}
