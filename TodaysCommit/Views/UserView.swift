import SwiftUI

struct UserView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var myCommits: [CommitData] = []
  @State private var myPlaces: [PlaceData] = []
  let placeColor: [Color] = [.yellow, .gray, .brown]
  let placeImage: [String] = ["gold", "silver", "bronze"]

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
            EmptyCard(title: "아직 커밋한 내역이 없어요.", subtitle: "오늘의 커밋을 시작해보세요.")
              .padding()
          }
            
          HStack {
            Text("랭킹 커밋 장소")
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
          if !myPlaces.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(Array(myPlaces.enumerated()), id: \.element.id) { index, placeData in
                  ZStack(alignment: .topLeading) {
                    PlaceItem(
                      placeData: placeData,
                      grassColor: placeColor[index],
                      onTap: {}
                    )
                    .frame(width: 240)
                        
                    Image(placeImage[index])
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .frame(width: 22, height: 22)
                      .offset(x: 10, y: -10)
                  }
                }
              }
              .padding()
            }
           
          } else {
            EmptyCard(title: "아직 심어진 잔디가 없어요.", subtitle: "오늘의 커밋을 완료해보세요.")
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
          let commitRes = try await CommitAPI.getMyCommit(of: 10)
          let placeRes = try await PlaceAPI.getMyPlaces(limit: 3)
  
          myCommits = commitRes.commits
          myPlaces = placeRes.places
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
