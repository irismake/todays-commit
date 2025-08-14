import SwiftUI

struct CommitLocationView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var locationManager: LocationManager
  @State var draw: Bool = false
  @State private var showCommitView = false
  @StateObject private var layout = LayoutMetrics()
  @State var placeAddress: String?
  @State var placeName: String?

  var body: some View {
    VStack {
      ZStack {
        Text("오늘의 커밋 시작")
          .font(.headline)
          .fontWeight(.bold)
        HStack {
          Spacer()
          Button(action: { dismiss() }) {
            Image(systemName: "xmark")
              .foregroundColor(.black)
              .padding(8)
          }
        }
      }
      .padding(.horizontal)
      .padding(.vertical)
      .background(GeometryReader { proxy in
        Color.clear.onAppear {
          layout.appBarHeight = proxy.frame(in: .global).minY
        }
      })
          
      ZStack(alignment: .bottom) {
        KakaoMapView(draw: $draw)
          .onAppear { draw = true }
          .onDisappear { draw = false }
          .ignoresSafeArea(edges: .bottom)
          .environmentObject(layout)
          .environmentObject(locationManager)
              
        VStack {
          if locationManager.isOverlayActive {
            PlaceNotFoundOverlay(
              placeAddress: placeAddress,
              onCommit: {
                showCommitView = true
              }
            )
           
          } else {
            CompleteButton(onComplete: {
              do {
                let overlayVC = Overlay.show(LoadingView())
                defer { overlayVC.dismiss(animated: true) }
                    
                let placeLocation = locationManager.placeLocation
                let locationRes = try await getLocationData(placeLocation)
                      
                let addrress = locationRes.address
                let pnu = locationRes.pnu
                placeAddress = addrress
                let placeCheck = try await PlaceAPI.checkPlace(pnu)
                print(placeCheck)
                if placeCheck.exists {
                  if placeCheck.name != nil {
                    placeName = placeCheck.name
                  }
                  showCommitView = true
                } else {
                  locationManager.activateOverlay()
                }
              } catch {
                print("위치 데이터 로드 실패:", error)
              }
                
            }, title: "커밋하기", color: Color(red: 0.0, green: 0.7, blue: 0.3))
              .padding(.vertical)
              .padding(.bottom, 20)
              .padding(.horizontal)
          }
        }
        .background(
          GeometryReader { proxy in
            Color.clear.onAppear {
              layout.bottomSafeAreaHeight = proxy.frame(in: .global).minY
            }
          }
        )
        .sheet(isPresented: $showCommitView) {
          if let placeAddress {
            CommitView(
              commitAddress: placeAddress,
              placeName: placeName
            )
          } else {
            Text("주소 정보가 없습니다.")
          }
        }
      }
    }
    
    .ignoresSafeArea(edges: .bottom)
  }
}

func getLocationData(_ location: Location?) async throws -> LocationResponse {
  guard let location else {
    throw URLError(.badURL)
  }
  return try await LocationAPI.getPnu(lat: location.lat, lon: location.lon)
}

struct CommitLocationView_Previews: PreviewProvider {
  static var previews: some View {
    CommitLocationView()
  }
}
