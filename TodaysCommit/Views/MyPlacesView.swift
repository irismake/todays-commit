import SwiftUI

struct MyPlacesView: View {
  @Environment(\.dismiss) private var dismiss
  @State var myPlaces: [PlaceData]
  @State var nextCursor: String?
    
  @State private var isLoading = false

  var body: some View {
    VStack {
      HStack {
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.primary)
        }
        Spacer()
        Text("나의 잔디 랭킹")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
                
        Spacer()
      }
      .padding()
      
      if !myPlaces.isEmpty {
        ScrollView(showsIndicators: false) {
          LazyVStack {
            ForEach(Array(myPlaces.enumerated()), id: \.element.id) {
              index, placeData in

              HStack(alignment: .center, spacing: 12) {
                Text("\(index + 1)")
                  .font(.headline)
                                  
                CommitAuthItem(content: "\(placeData.commitCount)회")
                  .aspectRatio(1, contentMode: .fit)
                  .fixedSize(horizontal: true, vertical: false)
                  
                HistoryItem(
                  placeName: placeData.name,
                  placeAddress: placeData.address,
                  pnu: placeData.pnu
                )
              }
            }
                    
            if nextCursor != nil {
              ProgressView()
                .onAppear {
                  fetchPlaces()
                }
            } else {
              Text("모든 장소를 불러왔습니다.")
                .font(.subheadline)
                .foregroundColor(.secondary.opacity(0.5))
                .padding()
            }
          }
          .padding()
        }
      } else {
        EmptyCard(title: "아직 심어진 잔디가 없어요.", subtitle: "오늘의 커밋을 완료해보세요.")
          .padding()
        Spacer()
      }
    }
  }

  private func fetchPlaces() {
    guard !isLoading else {
      return
    }
    isLoading = true
        
    Task {
      let overlayVC = Overlay.show(LoadingView())
      defer {
        overlayVC.dismiss(animated: true)
        isLoading = false
      }
            
      do {
        let placeRes = try await PlaceAPI.getMyPlaces(cursor: nextCursor)
                
        myPlaces.append(contentsOf: placeRes.places)
        nextCursor = placeRes.nextCursor
                
        print("✅ Fetched \(placeRes.places.count) new commits. Next cursor: \(String(describing: nextCursor))")
      } catch {
        print("❌ getMyPlaces: \(error.localizedDescription)")
        nextCursor = nil
      }
    }
  }
}
