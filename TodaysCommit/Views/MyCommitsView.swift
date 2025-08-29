import SwiftUI

struct MyCommitsView: View {
  @Environment(\.dismiss) private var dismiss
  @State var myCommits: [CommitData] = []
  @State var nextCursor: Int?
    
  @State private var isLoading = false

  var body: some View {
    VStack {
      HStack {
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.primary)
        }
        Spacer()
        Text("커밋 히스토리")
          .font(.subheadline)
          .foregroundColor(.primary)
          .fontWeight(.semibold)
                
        Spacer()
      }
      .padding()
      
      if !myCommits.isEmpty {
        ScrollView(showsIndicators: false) {
          LazyVStack(spacing: 20) {
            ForEach(myCommits, id: \.id) { commit in
              HStack {
                CommitItem(onTap: {}, commitData: commit)
              }
              .padding(.horizontal)
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
          }.padding(.top, 20)
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
      try? await Task.sleep(nanoseconds: 1_000_000_000)
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
