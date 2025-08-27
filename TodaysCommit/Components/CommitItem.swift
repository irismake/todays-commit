import SwiftUI

struct CommitItem: View {
  var onTap: () async -> Void
  let commitData: CommitData
  
  var body: some View {
    Button(action: {
      Task {
        await onTap()
      }
    }) {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text(commitData.placeName ?? "N/A")
            .font(.headline)
            .foregroundColor(.primary)
            .lineLimit(1)
              
          Spacer()
              
          Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.gray.opacity(0.6))
        }
      
        CommitAuthItem(createdAt: commitData.createdAt)
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
      CommitItem(
        onTap: {},
        commitData: CommitData(
          commitId: 2,
          userName: nil,
          createdAt: "2025-08-26T06:07:25.470490",
          pnu: Optional(1129013300106540034),
          placeName: Optional("라미카페")
        )
      )
      CommitItem(
        onTap: {},
        commitData: CommitData(
          commitId: 2,
          userName: nil,
          createdAt: "2025-08-26T06:07:25.470490",
          pnu: Optional(1129013300106540034),
          placeName: Optional("라미카페")
        )
      )
    }
    .padding()
  }
}
