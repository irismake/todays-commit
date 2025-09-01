import SwiftUI

struct MyCommitsView: View {
  @Environment(\.dismiss) private var dismiss
  @State var myCommits: [CommitData]
  @State var nextCursor: Int?
    
  @State private var isLoading = false
    
  var groupedPlaces: [(key: String, value: [CommitData])] {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"

    let groups = Dictionary(grouping: myCommits) { commit in
      let inputFormatter = DateFormatter()
      inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
      inputFormatter.locale = Locale(identifier: "en_US_POSIX")
      inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

      if let date = inputFormatter.date(from: commit.createdAt) {
        return formatter.string(from: date)
      } else {
        return "yyyy-MM-dd"
      }
    }
    return groups.sorted { $0.key > $1.key }
  }
    
  var body: some View {
    VStack {
      HStack {
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.primary)
        }
        Spacer()
        Text("커밋 히스토리")
          .font(.headline)
          .fontWeight(.semibold)
          .foregroundColor(.primary)
                
        Spacer()
      }
      .padding()
      
      if !myCommits.isEmpty {
        ScrollView(showsIndicators: false) {
          LazyVStack {
            VStack(spacing: 20) {
              ForEach(groupedPlaces, id: \.key) { date, commits in
                VStack(alignment: .leading) {
                  HStack(spacing: 8) {
                    Text(date)
                      .font(.footnote)
                      .fontWeight(.semibold)
                      .foregroundColor(.primary)
                      .padding(.vertical)
                                           
                    Rectangle()
                      .fill(Color.secondary.opacity(0.3))
                      .frame(height: 1)
                  }
                              
                  ForEach(commits, id: \.id) { commit in
                    HStack(alignment: .center, spacing: 12) {
                      CommitAuthItem(content: commit.createdAt)
                        .aspectRatio(1, contentMode: .fit)
                        .fixedSize(horizontal: true, vertical: false)
                        
                      HistoryItem(
                        placeName: commit.placeName ?? "N/A",
                        placeAddress: commit.address ?? "N/A",
                        pnu: commit.pnu ?? "N/A"
                      )
                    }
                    .fixedSize(horizontal: false, vertical: true)
                  }
                }
              }
            }
            if nextCursor != nil {
              ProgressView()
                .onAppear {
                  fetchCommits()
                }
            } else {
              Text("모든 커밋을 불러왔습니다.")
                .font(.subheadline)
                .foregroundColor(.secondary.opacity(0.5))
                .padding()
            }
          }
          .padding(.horizontal)
        }
      } else {
        EmptyCard(title: "아직 커밋한 내역이 없어요.", subtitle: "오늘의 커밋을 시작해보세요.")
          .padding()
        Spacer()
      }
    }
  }

  private func fetchCommits() {
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
        let commitRes = try await CommitAPI.getMyCommit(cursor: nextCursor)
                
        myCommits.append(contentsOf: commitRes.commits)
        nextCursor = commitRes.nextCursor
                
        print("✅ Fetched \(commitRes.commits.count) new commits. Next cursor: \(String(describing: nextCursor))")
      } catch {
        print("❌ getMyCommits: \(error.localizedDescription)")
        nextCursor = nil
      }
    }
  }
}
