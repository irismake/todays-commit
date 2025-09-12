import SwiftUI

struct SearchLocationView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var locationManager: LocationManager
  @EnvironmentObject var mapManager: MapManager
    
  var body: some View {
    VStack {
      ZStack {
        Text("위치 검색")
          .font(.headline)
          .fontWeight(.bold)
          .foregroundColor(.primary)
                
        HStack {
          Spacer()
          Button(action: {
            dismiss()
          }) {
            Image(systemName: "xmark")
              .foregroundColor(.primary)
              .padding(8)
          }
        }
      }
      .padding()

      TextField("위치를 검색해주세요.", text: $locationManager.query)
        .padding(.horizontal)
        .padding(.vertical)
        .background(
          RoundedRectangle(cornerRadius: 8)
            .stroke(.secondary, lineWidth: 1)
        )
        .padding(.horizontal)

      if locationManager.searchResults.isEmpty {
        Spacer()
        Text("검색 결과가 없습니다.")
          .foregroundColor(.gray)
          .padding()
        Spacer()
      } else {
        List(locationManager.searchResults) { result in
          Button(action: {
            Task {
              if let lat = Double(result.y), let lon = Double(result.x) {
                await fetchMapDataForQuery(lat: lat, lon: lon)
                dismiss()
              }
            }
          }) {
            VStack(alignment: .leading, spacing: 6) {
              Text(result.placeName)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
              HStack {
                Text(result.addressName)
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
          }
        }
      }
      AdBanner()
        .frame(height: 50)
        .background(Color(UIColor.systemBackground))
        .padding(.top, 8)
    }
    .ignoresSafeArea(.keyboard)
  }

  func fetchMapDataForQuery(lat: Double, lon: Double) async {
    do {
      let locationResponse = try await LocationAPI.getPnu(lat: lat, lon: lon)
      locationManager.currentAddress = locationResponse.address
      let cells = try await MapAPI.getCell(locationResponse.pnu)

      mapManager.mapLevel = 1

      for cell in cells {
        let mapId = cell.mapId
        let mapLevel = cell.mapLevel

        if mapLevel == 1 {
          await mapManager.fetchMapData(of: mapId, coordId: cell.cellData.coordId)
        }
      }
    } catch {
      print("❌ 쿼리 맵 데이터 로드 실패: \(error.localizedDescription)")
    }
  }
}
