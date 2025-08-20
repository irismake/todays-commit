import SwiftUI

struct CommitAuthItem: View {
  let createdAt: String
  let userName: String
    
  var body: some View {
    HStack {
      HStack(spacing: 10) {
        Image("icon_commit")
          .aspectRatio(contentMode: .fit)
          .frame(height: 10)
          
        Text(createdAt)
          .font(.caption)
          .foregroundColor(.secondary)
          
        Text(userName)
          .font(.caption)
          .foregroundColor(.primary)
          .fontWeight(.bold)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(10)
      .background(Color.gray.opacity(0.1))
      .cornerRadius(200)
    }
  }

  struct CommitAuthItem_Previews: PreviewProvider {
    static var previews: some View {
      CommitAuthItem(createdAt: "2025-07-06 13:09", userName: "김가희")
    }
  }
}
