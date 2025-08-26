import SwiftUI

struct CommitItem: View {
  var onTap: () async -> Void
  let placeName: String
  
  var body: some View {
    Button(action: {
      Task {
        await onTap()
      }
    }) {
      VStack(alignment: .leading, spacing: 20) {
        HStack {
          Text(placeName)
            .font(.headline)
            .foregroundColor(.primary)
            .lineLimit(1)
              
          Spacer()
              
          Image(systemName: "chevron.right")
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.gray.opacity(0.6))
        }
      
        CommitAuthItem(createdAt: "2025-08-24 16:09")
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
      CommitItem(onTap: {}, placeName: "커피스토어")
      CommitItem(onTap: {}, placeName: "스타벅스 성신여대점")
    }
    .padding()
  }
}
