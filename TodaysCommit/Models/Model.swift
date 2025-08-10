import SwiftUI

struct RankUser: Decodable {
  let user_name: String
  let commit_count: Int
}

struct SubZoneCommit: Decodable {
  let zone: Int
  let commit_count: Int
}

struct TotalGrassCommit: Decodable {
  let x: Int
  let y: Int
  let total_commit_count: Int
  let rank_users: [RankUser]
}

struct UserGrassCommit: Decodable {
  let x: Int
  let y: Int
  let total_commit_count: Int
  let sub_zone_commit: [SubZoneCommit]
}

enum GrassCommit {
  case total(TotalGrassCommit)
  case user(UserGrassCommit)
}

extension GrassCommit {
  var x: Int {
    switch self {
    case let .total(data): return data.x
    case let .user(data): return data.x
    }
  }

  var y: Int {
    switch self {
    case let .total(data): return data.y
    case let .user(data): return data.y
    }
  }

  var totalCommitCount: Int {
    switch self {
    case let .total(data): return data.total_commit_count
    case let .user(data): return data.total_commit_count
    }
  }

  var rankUsers: [RankUser]? {
    if case let .total(data) = self {
      return data.rank_users
    }
    return nil
  }

  var subZoneCommit: [SubZoneCommit]? {
    if case let .user(data) = self {
      return data.sub_zone_commit
    }
    return nil
  }
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
