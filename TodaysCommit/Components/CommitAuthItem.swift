import SwiftUI

struct CommitAuthItem: View {
  let createdAt: String
  var userName: String?
    
  func formatCreatedAt(_ raw: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    outputFormatter.locale = Locale(identifier: "ko_KR")
    outputFormatter.timeZone = TimeZone.current
        
    if let date = inputFormatter.date(from: raw) {
      return outputFormatter.string(from: date)
    } else {
      return raw
    }
  }

  var body: some View {
    HStack {
      HStack(spacing: 10) {
        Image("icon_commit")
          .resizable()
          .scaledToFit()
          .frame(height: 10)
          
        Text(formatCreatedAt(createdAt))
          .font(.caption)
          .foregroundColor(.secondary)
         
        if let unwrappedUserName = userName {
          Text(unwrappedUserName)
            .font(.caption)
            .foregroundColor(.primary)
            .fontWeight(.bold)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(userName != nil ? 10 : 4)
      .background(Color.green.opacity(0.1))
      .cornerRadius(200)
    }
  }

  struct CommitAuthItem_Previews: PreviewProvider {
    static var previews: some View {
      CommitAuthItem(createdAt: "2025-07-06 13:09", userName: "김가희")
    }
  }
}
