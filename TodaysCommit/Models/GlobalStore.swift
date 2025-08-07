import Foundation

final class GlobalStore {
  static let shared = GlobalStore()
  private init() {}
    
  var mapDataLevel0: [Int: [MapData]]?
  var mapDataLevel1: [Int: [MapData]]?
  var mapDataLevel2: [Int: [MapData]]?
}
