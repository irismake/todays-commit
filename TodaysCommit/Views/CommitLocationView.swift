import SwiftUI

struct CommitLocationView: View {
  @Environment(\.dismiss) private var dismiss
  @State var draw: Bool = false
  @Environment(\.colorScheme) var colorScheme
  @EnvironmentObject var layoutManager: LayoutManager
  @EnvironmentObject var placeManager: PlaceManager
  @State private var placeData: PlaceBase?
  @State private var showSheet = false

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
      AdBanner()
        .frame(height: 50)
        .padding(.bottom, 8)
            
      ZStack(alignment: .bottom) {
        KakaoMapView(draw: $draw)
          .onAppear {
            draw = true
            Overlay.show(LoadingView())
          }
          .onDisappear { draw = false }
          .ignoresSafeArea(edges: .bottom)
          .environmentObject(layoutManager)
          .environmentObject(placeManager)
                
        Group {
          if layoutManager.isOverlayActive {
            PlaceNotFoundOverlay(
              placeAddress: placeData?.address,
              onCommit: {
                showSheet = true
                // layoutManager.deactivateOverlay()
              }
            )
          } else {
            CompleteButton(
              onComplete: { await handleCommitAction() },
              title: "커밋하기",
              color: Color(red: 0.0, green: 0.7, blue: 0.3)
            )
            .padding(.vertical)
            .padding(.bottom, 30)
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
      }
    }
    .sheet(isPresented: $showSheet) {
      if let placeData {
        CommitView(placeData: placeData) {
          Overlay.show(Toast(message: "잔디가 성공적으로 심어졌어요."), autoDismissAfter: 2)
          dismiss()
        }
      }
    }
    .ignoresSafeArea(edges: .bottom)
  }

  private func handleCommitAction() async {
    let placeCheck = await checkPlace()

    if let current = placeData {
      placeData = PlaceBase(
        pnu: current.pnu,
        name: placeCheck.name ?? "",
        address: current.address,
        x: current.x,
        y: current.y
      )
    }

    if placeCheck.exists {
      showSheet = true
    } else {
      layoutManager.activateOverlay()
    }
  }
    
  private func checkPlace() async -> PlaceChcek {
    let overlayVC = Overlay.show(LoadingView())
    defer { overlayVC.dismiss(animated: true) }
        
    do {
      guard let location = placeManager.placeLocation else {
        throw URLError(.badURL)
      }
      let locationRes = try await LocationAPI.getPnu(lat: location.lat, lon: location.lon)

      placeData = PlaceBase(
        pnu: locationRes.pnu,
        name: "",
        address: locationRes.address,
        x: location.lat,
        y: location.lon
      )
      return try await PlaceAPI.checkPlace(locationRes.pnu)
    } catch {
      print("❌ checkPlace: \(error.localizedDescription)")
      return PlaceChcek(exists: false, name: nil)
    }
  }
}
