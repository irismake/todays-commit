import SwiftUI

enum Route: Identifiable {
  case login
  case commit

  var id: String {
    switch self {
    case .login: "login"
    case .commit: "commit"
    }
  }
}
