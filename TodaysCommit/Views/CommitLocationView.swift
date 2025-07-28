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

        VStack(alignment: .leading, spacing: 12) {
          if !existPlace {
            Text("장소 정보를 찾을 수 없어요.")
              .font(.subheadline)
              .fontWeight(.semibold)
              .foregroundColor(.orange)

            Text("위치를 이동해보세요.")
              .font(.caption)
              .foregroundColor(.gray)
          }

          Button(action: {
            print("커밋 진행")
      
            if existPlace == false {
              showCommitView = true
            }
            existPlace = false
          }) {
            Text(existPlace ? "커밋하기" : "그래도 이 위치로 커밋하기")
              .font(.headline)
              .fontWeight(.bold)
              .frame(maxWidth: .infinity)
              .padding()
              .background(existPlace ? Color.green : Color.orange)
              .foregroundColor(.white)
              .cornerRadius(12)
              .background(
                GeometryReader { proxy in
                  Color.clear.onAppear {
                    layout.bottomSafeAreaHeight = proxy.frame(in: .global).minY
                  }
                }
              )
          }
          .sheet(isPresented: $showCommitView) {
            CommitView()
          }
        }
        .padding(.vertical)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(
          (existPlace ? Color.clear : Color(red: 1.0, green: 0.956, blue: 0.902))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .ignoresSafeArea(edges: .bottom)
        )
      }
    }
    .background(Color.white)
  }
}

struct CommitLocationView_Previews: PreviewProvider {
  static var previews: some View {
    CommitLocationView()
  }
}
