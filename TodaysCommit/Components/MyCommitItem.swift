import SwiftUI

struct MyCommitItem: View {
  var onTap: () async -> Void
  let commitData: CommitData
  
  var body: some View {
    Button(action: {
      Task {
        await onTap()
      }
    }) {
      VStack(alignment: .leading, spacing: 20) {
        Text(commitData.placeName ?? "N/A")
          .font(.headline)
          .foregroundColor(.primary)
          .lineLimit(1)
          
        CommitHistoryItem(createdAt: commitData.createdAt)
      }
      .padding()
      .background(Color(.systemBackground))
      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .stroke(.primary.opacity(0.3), lineWidth: 1)
      )
      .shadow(color: .primary.opacity(0.1), radius: 6, x: 0, y: 0)
    }
    .buttonStyle(.plain)
  }
}

struct CommitItem_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 20) {
      MyCommitItem(
        onTap: {},
        commitData: CommitData(
          commitId: 2,
          userName: nil,
          createdAt: "2025-08-26T06:07:25.470490",
          pnu: Optional("1129013300106540034"),
          placeName: Optional("라미카페"),
          address: Optional("서울 중구 세종대로 110")
        )
      )
      MyCommitItem(
        onTap: {},
        commitData: CommitData(
          commitId: 2,
          userName: nil,
          createdAt: "2025-08-26T06:07:25.470490",
          pnu: Optional("1129013300106540034"),
          placeName: Optional("라미카페"),
          address: Optional("서울 중구 세종대로 110")
        )
      )
    }
    .padding()
  }
}
