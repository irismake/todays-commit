import SwiftUI

struct CommitAuthItem: View {
  let content: String
    
  var body: some View {
    VStack(spacing: 6) {
      Image("icon_commit")
        .resizable()
        .scaledToFit()
        .frame(height: 30)
            
      Text(formatToTime(content))
        .font(.system(size: 10, weight: .semibold))
        .foregroundColor(.primary)
    }
    .padding(10)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .background(Color.green.opacity(0.1))
    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
  }
    
  func formatToTime(_ raw: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
    inputFormatter.locale = Locale(identifier: "en_US_POSIX")
    inputFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "HH:mm"
    outputFormatter.locale = Locale(identifier: "ko_KR")
    outputFormatter.timeZone = TimeZone.current
        
    if let date = inputFormatter.date(from: raw) {
      return outputFormatter.string(from: date)
    } else {
      return raw
    }
  }
}
