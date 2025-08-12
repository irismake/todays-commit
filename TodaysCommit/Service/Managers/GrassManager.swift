import Combine
import SwiftUI

final class GrassManager: ObservableObject {
  static let shared = GrassManager()
  var totalGrassData: [GrassData] = []
  var myGrassData: [GrassData] = []

  private init() {}
  @MainActor
  func fetchGrassData(of mapId: Int) async {
    do {
      let overlayVC = Overlay.show(LoadingView())
      defer { overlayVC.dismiss(animated: true) }
      let grassDataResponse = try await GrassAPI.getGrass(mapId)
      totalGrassData = grassDataResponse.grassData
      print("ddd")
    } catch {
      print("❌ fetchGrassData : \(error.localizedDescription)")
    }
  }
}
