import Foundation

final class GlobalStore {
  static let shared = GlobalStore()
  private init() {}
    
  var gridSize: Int = 25
}
