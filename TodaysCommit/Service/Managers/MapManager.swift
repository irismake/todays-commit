import SwiftUI

final class MapManager: ObservableObject {
  @Published var currentMapData: [Int: [CellData]]?
  @Published var currentMapId: Int?
  @Published var mapLevel: Int = 1
  @Published var gpsCells: [CellResponse] = []
  @Published var selectedCell: CellData?
  @Published var selectedGrassColor: Color = .lv_0

  var mapName: String {
    guard let mapCode = currentMapData?.keys.first else {
      return "오늘의 커밋"
    }
    return nominationData[mapCode] ?? "N/A"
  }

  var selectedZoneName: String {
    guard let zoneCode = selectedCell?.zoneCode else {
      return "잔디를 클릭해주세요."
    }
    return nominationData[zoneCode] ?? "잔디를 클릭해주세요."
  }

  var gpsCoordId: Int? {
    guard let currentCell = gpsCells.first(where: { $0.mapLevel == self.mapLevel }),
          currentCell.mapId == currentMapId
    else {
      return nil
    }
    return currentCell.cellData.coordId
  }
    
  var zoomOutDisabled: Bool {
    !(0 ... 1).contains(mapLevel)
  }

  var zoomInDisabled: Bool {
    !(1 ... 2).contains(mapLevel)
  }
      
  func changeMapLevel(_ zoomingIn: Bool) {
    switch nextMapId(zoomingIn: zoomingIn) {
    case let .success(mapId):
      mapLevel += zoomingIn ? -1 : 1
      Task {
        await fetchMapData(of: mapId)
      }

    case .noSelectedCell:
      Overlay.show(
        ConfirmOverlay(title: "잔디를 클릭해주세요", content: "확대하려면 먼저 잔디를 선택해 주세요.")
      )
      return

    case .noNextMapId:
      Overlay.show(
        ConfirmOverlay(
          title: "\(selectedZoneName) 지도 요청",
          content: "요청하신 지역은 서비스 개선에 참고할게요.\n함께 지도를 더 넓혀볼까요?",
          showToast: true
        )
      )
      return
    }
  }

  private func nextMapId(zoomingIn: Bool) -> MapIdResult {
    if zoomingIn {
      guard let subZoneCode = selectedCell?.zoneCode else {
        return .noSelectedCell
      }
      if let mapId = mapCodeId[subZoneCode]?.mapId {
        return .success(mapId)
      }
      return .noNextMapId
    } else {
      guard let mapCode = currentMapData?.keys.first else {
        return .noSelectedCell
      }
      let upperZoneCode = getUpperZoneCode(from: mapCode)
      if let mapId = mapCodeId[upperZoneCode]?.mapId {
        return .success(mapId)
      }
      return .noNextMapId
    }
  }
    
  func getMapData() -> [CellData]? {
    currentMapData?
      .values
      .flatMap { $0 }
  }
    
  @MainActor
  func updateCell(newCoordId: Int?, grassColor: Color) async {
    let overlayVC = Overlay.show(LoadingView())
    defer { overlayVC.dismiss(animated: true) }
    selectedGrassColor = grassColor

    selectedCell = currentMapData?
      .values
      .flatMap { $0 }
      .first { $0.coordId == newCoordId }
  }

  @MainActor
  func fetchMapData(of mapId: Int? = nil, coordId: Int? = nil) async {
    let overlayVC = Overlay.show(LoadingView())
    defer { overlayVC.dismiss(animated: true) }
    
    guard let mapId = mapId ?? gpsCells.first(where: { $0.mapLevel == self.mapLevel })?.mapId else {
      print("❌ fetchMapData: mapId 없음")
      return
    }
      
    do {
      if currentMapId != mapId {
        let mapRes = try await MapAPI.getMap(mapId)
        currentMapData = [mapRes.mapCode: mapRes.mapData]
      }
      currentMapId = mapId
      let targetCoordId = coordId ?? gpsCoordId
      await updateCell(newCoordId: targetCoordId, grassColor: targetCoordId != nil ? .primary : .lv_0)
    } catch {
      print("❌ fetchMapData : \(error.localizedDescription)")
    }
  }
    
  func getUpperZoneCode(from code: Int) -> Int {
    let codeStr = String(code)
    if codeStr.count == 2 {
      return 410
    } else {
      let upperCodeStr = codeStr.dropLast(3)
      guard let upperCode = Int(upperCodeStr) else {
        // 변환 실패 시 기본값 지정
        return 0
      }
      return upperCode
    }
  }
}
