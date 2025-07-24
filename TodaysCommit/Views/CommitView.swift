import SwiftUI

struct CommitView: View {
  @Environment(\.dismiss) private var dismiss
  @State var draw: Bool = false

  var body: some View {
    VStack(spacing: 20) {
      ZStack {
        Text("오늘의 커밋 완료")
          .font(.headline)
          .fontWeight(.bold)
          
        HStack {
          Spacer()
          Button(action: {
            dismiss()
          }) {
            Image(systemName: "xmark")
              .foregroundColor(.black)
              .padding(8)
          }
        }
      }
       
      KakaoMapView(draw: $draw)
        .onAppear(perform: {
          draw = true
        }).onDisappear(perform: {
          draw = false
        })
        .frame(maxWidth: .infinity)
        .frame(height: 140)
        .clipShape(RoundedRectangle(cornerRadius: 20))
      HStack {
        Text("서울특별시 용산구 한남동 683-140")
          .font(.subheadline)
          .fontWeight(.semibold)
          .foregroundColor(.gray)
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.gray.opacity(0.1))
          .cornerRadius(12)
      }

      Spacer()

      Button(action: {
        print("잔디 심기 실행")
      }) {
        Text("잔디 심기")
          .font(.headline)
          .fontWeight(.bold)
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.green)
          .foregroundColor(.white)
          .cornerRadius(12)
      }
      .padding(.bottom, 20)
    }
    .padding()
    .background(Color.white)
    .ignoresSafeArea(edges: .bottom)
  }
}

struct CommitView_Previews: PreviewProvider {
  static var previews: some View {
    CommitView()
  }
}
