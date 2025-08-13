import SwiftUI

struct CommitLocationView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var locationManager: LocationManager
  @State var draw: Bool = false
  @State private var showCommitView = false
  @StateObject private var layout = LayoutMetrics()

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
            PlaceNotFoundOverlay {
              showCommitView = true
            }
           
          } else {
            CompleteButton(onComplete: {
              print("커밋 진행")
              locationManager.activateOverlay()
                    
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
          CommitView()
        }
      }
    }
    
    .ignoresSafeArea(edges: .bottom)
  }
}

struct CommitLocationView_Previews: PreviewProvider {
  static var previews: some View {
    CommitLocationView()
  }
}
