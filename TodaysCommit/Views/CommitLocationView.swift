import SwiftUI

struct CommitLocationView: View {
  @Environment(\.dismiss) private var dismiss
  @State var draw: Bool = false
  @State private var existPlace: Bool = true
  @State private var showCommitView = false
  @StateObject private var layout = LayoutMetrics()

  var body: some View {
    VStack {
      ZStack {
        Text("오늘의 커밋 완료")
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
              
        VStack {
          if existPlace {
            CompleteButton(onComplete: {
              print("커밋 진행")
                                       
              if existPlace == false {
                showCommitView = true
              }
              existPlace = false
                  
            }, title: "커밋하기", color: Color(red: 0.0, green: 0.7, blue: 0.3))
              .padding(.vertical)
              .padding(.bottom, 20)
              .padding(.horizontal)
          } else {
            PlaceNotFoundOverlay {
              showCommitView = true
            }
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
