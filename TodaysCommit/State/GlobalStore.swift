import Foundation
import SwiftUI

final class GlobalStore {
  static let shared = GlobalStore()
  private init() {
    screenWidth = UIScreen.main.bounds.width
    screenHeight = UIScreen.main.bounds.height
  }
    
  var gridSize: Int = 25
  var screenWidth: CGFloat
  var screenHeight: CGFloat
}
