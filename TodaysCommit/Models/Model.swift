import SwiftUI

enum SortOption: String, CaseIterable, Identifiable {
  case recent = "최신순"
  case popular = "인기순"
  var id: String { rawValue }
}

enum PlaceScope: Hashable { case main, my }

struct PlaceCacheKey: Hashable {
  let mapId: Int
  let coordId: Int
  let sort: SortOption
  let scope: PlaceScope
}

struct MailData {
  let recipient: String = "gitgrassgrowing@gmail.com"
  let subject: String
  let content: String
    
  var formattedBody: String {
    """
    \(content)
    
    **********
    Device: \(UIDevice.current.model), iOS \(UIDevice.current.systemVersion)
    App: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "알 수 없음")
    """
  }
    
  var encodedSubject: String {
    subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
  }
    
  var encodedBody: String {
    let tokenizedBody = formattedBody.replacingOccurrences(of: "\n", with: "LINE_BREAK_TOKEN")
    let encoded = tokenizedBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    return encoded.replacingOccurrences(of: "LINE_BREAK_TOKEN", with: "%0D%0A")
  }
    
  var mailtoURL: URL? {
    URL(string: "mailto:\(recipient)?subject=\(encodedSubject)&body=\(encodedBody)")
  }
}
