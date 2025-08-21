import SwiftUI

class LayoutManager: ObservableObject {
  @Published var appBarHeight: CGFloat = 0
  @Published var bottomSafeAreaHeight: CGFloat = 0
  @Published var isOverlayActive: Bool = false

  func deactivateOverlay() {
    isOverlayActive = false
  }

  func activateOverlay() {
    isOverlayActive = true
  }
}
