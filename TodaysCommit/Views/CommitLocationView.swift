import SwiftUI

struct CommitLocationView: View {
  @Environment(\.dismiss) private var dismiss
  @State var draw: Bool = false
  @Environment(\.colorScheme) var colorScheme
  @EnvironmentObject var layoutManager: LayoutManager
  @EnvironmentObject var placeManager: PlaceManager
  @State var placeAddress: String?
  @State var placePnu: String?
  @State private var placeData: PlaceBase?
    
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
              .foregroundColor(colorScheme == .dark ? .white : .black)
              .padding(8)
          }
        }
      }
      .padding(.horizontal)
      .padding(.vertical)
      .background(GeometryReader { proxy in
        Color.clear.onAppear {
          layoutManager.appBarHeight = proxy.frame(in: .global).minY
        }
      })
            
      ZStack(alignment: .bottom) {
        KakaoMapView(draw: $draw)
          .onAppear { draw = true }
          .onDisappear { draw = false }
          .ignoresSafeArea(edges: .bottom)
          .environmentObject(layoutManager)
          .environmentObject(placeManager)
                
        VStack {
          if layoutManager.isOverlayActive {
            PlaceNotFoundOverlay(
              placeAddress: placeAddress,
              onCommit: {
                guard let placePnu,
                      let placeAddress,
                      let placeLocation = placeManager.placeLocation
                else {
                  return
                }
                placeData = PlaceBase(
                  pnu: placePnu,
                  name: "",
                  address: placeAddress,
                  x: placeLocation.lat,
                  y: placeLocation.lon
                )
              }
            )
                        
          } else {
            CompleteButton(onComplete: {
              await handleCommitAction()

            }, title: "커밋하기", color: Color(red: 0.0, green: 0.7, blue: 0.3))
              .padding(.bottom)
              .padding(.horizontal)
          }
        }
        .background(
          GeometryReader { proxy in
            Color.clear.onAppear {
              layoutManager.bottomSafeAreaHeight = proxy.frame(in: .global).minY
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
  }
    
  private func handleCommitAction() async {
    let placeCheck = await checkPlace()
    
    if placeCheck.exists {
      guard let placePnu,
            let placeAddress,
            let placeLocation = placeManager.placeLocation
      else {
        return
      }
            
      let placeName = placeCheck.name ?? ""
   
      placeData = PlaceBase(
        pnu: placePnu,
        name: placeName,
        address: placeAddress,
        x: placeLocation.lat,
        y: placeLocation.lon
      )

    } else {
      layoutManager.activateOverlay()
    }
  }
    
  private func checkPlace() async -> PlaceChcek {
    let overlayVC = Overlay.show(LoadingView())
    defer { overlayVC.dismiss(animated: true) }
        
    do {
      let placeLocation = placeManager.placeLocation
      let locationRes = try await getLocationData(placeLocation)
      let address = locationRes.address
      placePnu = locationRes.pnu
      placeAddress = address
      return try await PlaceAPI.checkPlace(locationRes.pnu)
    } catch {
      print("❌ handleCommitAction : \(error.localizedDescription)")
      return PlaceChcek(exists: false, name: nil)
    }
  }
}

func getLocationData(_ location: LocationBase?) async throws -> LocationResponse {
  guard let location else {
    throw URLError(.badURL)
  }
  return try await LocationAPI.getPnu(lat: location.lat, lon: location.lon)
}
