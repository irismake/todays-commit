import SwiftUI

struct CommitLocationView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var locationManager: LocationManager
  @State var draw: Bool = false
  @State private var showCommitView = false
  @StateObject private var layout = LayoutMetrics()
  @State var placeAddress: String?
  @State var placePnu: String?
  @State private var placeData: PlaceResponse?

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
                guard let placePnu,
                      let placeAddress,
                      let placeLocation = locationManager.placeLocation
                else {
                  return
                }
                placeData = PlaceResponse(
                  pnu: placePnu,
                  name: "",
                  address: placeAddress,
                  x: placeLocation.lat,
                  y: placeLocation.lon
                )
                showCommitView = true
              }
            )
           
          } else {
            CompleteButton(onComplete: {
              await handleCommitAction()
                
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
        .sheet(item: $placeData) { data in
          CommitView(placeData: data) {
            dismiss()
          }
        }
      }
    }
    
    .ignoresSafeArea(edges: .bottom)
  }

  private func handleCommitAction() async {
    let placeLocation = locationManager.placeLocation
    let locationRes = try await getLocationData(placeLocation)
    let address = locationRes.address
    placePnu = locationRes.pnu
    placeAddress = address
    let placeCheck = try await PlaceAPI.checkPlace(locationRes.pnu)

    if placeCheck.exists {
      guard let placeAddress,
            let placeLocation
      else {
        return
      }
      let placeName = placeCheck.name ?? ""
      placeData = PlaceResponse(
        pnu: locationRes.pnu,
        name: placeName,
        address: placeAddress,
        x: placeLocation.lat,
        y: placeLocation.lon
      )
      showCommitView = true
    } else {
      locationManager.activateOverlay()
    }
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
