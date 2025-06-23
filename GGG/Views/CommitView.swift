import SwiftUI

struct CommitView: View {
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack {
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
          }
        }
      }
      .padding()
      .background(Color.white)

      Spacer()

      HStack {
        Spacer()
        Button(action: {
          print("현재 위치로 이동")
        }) {
          Image(systemName: "location.fill")
            .foregroundColor(.blue)
            .padding(10)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(radius: 3)
        }
      }
      .padding()

      VStack(spacing: 20) {
        HStack {
          Text("서울특별시 용산구 한남동 683-140")
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)

        Button(action: {
          print("잔디 심기 실행")
        }) {
          Text("잔디 심기")
            .font(.headline)
            .fontWeight(.heavy)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding(.bottom, 30)
      }
      .padding()
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    .background(Color(.systemGroupedBackground))
    .ignoresSafeArea(edges: .bottom)
  }
}

struct CommitView_Previews: PreviewProvider {
  static var previews: some View {
    CommitView()
  }
}
