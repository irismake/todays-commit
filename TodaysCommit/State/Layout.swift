import SwiftUI

class LayoutMetrics: ObservableObject {
  @Published var appBarHeight: CGFloat = 0
  @Published var bottomSafeAreaHeight: CGFloat = 0
}
