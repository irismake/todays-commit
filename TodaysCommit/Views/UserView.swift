import SwiftUI

struct UserView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var myCommitData: CommitResponse?
  @State private var myPlaceData: PlaceResponse?
  @State private var userInfo: UserData?
  let placeColor: [Color] = [.yellow, .gray, .brown]
  let placeImage: [String] = ["gold", "silver", "bronze"]
  @State private var activeSheet: Route?
    
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.primary)
        }
        Spacer()
        Text("마이페이지")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
              
        Spacer()
      }
      .padding()
          
      ScrollView {
        VStack {
          if let userInfo {
            VStack {
              ProviderBadge(provider: userInfo.provider)
              Text(userInfo.userName)
                .font(.title)
                .foregroundColor(.primary)
                .fontWeight(.bold)
                .padding()
            }
            .padding(.vertical)
          } else {
            Text("사용자 정보 불러오는 중...")
              .font(.subheadline)
              .foregroundColor(.secondary)
              .fontWeight(.semibold)
              .padding()
          }
                  
          HStack {
            Text("커밋 히스토리")
              .font(.subheadline)
              .fontWeight(.semibold)
              .foregroundColor(.primary)
            Spacer()
            Button(action: {
              activeSheet = .myCommits
            }) {
              Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray.opacity(0.6))
            }
          }
          .padding(.top)
          .padding(.horizontal)
                  
          if let commitData = myCommitData {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(commitData.commits, id: \.id) { commit in
                  MyCommitItem(onTap: {}, commitData: commit)
                    .frame(width: 300)
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
            Button(action: {
              activeSheet = .myPlaces
            }) {
              Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.gray.opacity(0.6))
            }
          }
          .padding(.top)
          .padding(.horizontal)
          if let placeData = myPlaceData {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(Array(placeData.places.enumerated()), id: \.element.id) { index, place in
                  ZStack(alignment: .topLeading) {
                    MyPlaceItem(onTap: {}, placeData: place)
                      .frame(width: 300)
                      
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
    .fullScreenCover(item: $activeSheet) { sheet in
      switch sheet {
      case .myCommits:
        MyCommitsView(myCommits: myCommitData?.commits ?? [], nextCursor: myCommitData?.nextCursor)
      case .myPlaces:
        MyPlacesView(myPlaces: myPlaceData?.places ?? [], nextCursor: myPlaceData?.nextCursor)
      default:
        EmptyView()
      }
    }
    .onAppear {
      Task {
        let overlayVC = Overlay.show(LoadingView())
        defer { overlayVC.dismiss(animated: true) }
        do {
          let userRes = try await UserAPI.getUserInfo()
          let commitRes = try await CommitAPI.getMyCommit(cursor: nil)
          let placeRes = try await PlaceAPI.getMyPlaces(limit: 3, cursor: nil)

          userInfo = userRes
          myCommitData = commitRes
          myPlaceData = placeRes
        } catch {
          print("❌ getUserData: \(error.localizedDescription)")
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
