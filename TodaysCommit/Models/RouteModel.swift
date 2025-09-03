enum Route: Identifiable {
  case login
  case commitLocation
  case myCommits
  case myPlaces
  case user
  case placeDetail
  case setting
  case searchLocation

  var id: String {
    switch self {
    case .login: "login"
    case .commitLocation: "commitLocation"
    case .myCommits: "myCommits"
    case .myPlaces: "myPlaces"
    case .user: "user"
    case .placeDetail: "placeDetail"
    case .setting: "setting"
    case .searchLocation: "searchLocation"
    }
  }
}
