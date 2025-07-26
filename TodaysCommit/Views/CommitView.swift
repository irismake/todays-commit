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
              .padding(8)
          }
        }
      }
      .padding(.vertical)

      ScrollView {
        VStack(spacing: 20) {
          Group {
            VStack {}.background(Color.green)
              .frame(height: 200)
            Text("커밋 위치")
              .font(.subheadline)
              .fontWeight(.medium)
              .foregroundColor(.black)
              .frame(maxWidth: .infinity, alignment: .leading)

            Text("서울특별시 용산구 한남동 683-140")
              .font(.subheadline)
              .fontWeight(.semibold)
              .foregroundColor(.gray)
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.gray.opacity(0.1))
              .cornerRadius(12)

            Text("장소 이름")
              .font(.subheadline)
              .fontWeight(.medium)
              .foregroundColor(.black)
              .frame(maxWidth: .infinity, alignment: .leading)

            Text("맥심 플랜트")
              .font(.subheadline)
              .fontWeight(.semibold)
              .foregroundColor(.gray)
              .padding()
              .frame(maxWidth: .infinity)
              .background(Color.gray.opacity(0.1))
              .cornerRadius(12)
              
            Text("이 장소는 어때요?")
              .font(.subheadline)
              .fontWeight(.medium)
              .foregroundColor(.black)
              .frame(maxWidth: .infinity, alignment: .leading)
              
            Text("많은 사람들이 커밋한 장소예요")
              .font(.caption)
              .fontWeight(.medium)
              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          Spacer(minLength: 80)
        }
      }.scrollIndicators(.hidden)

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
    }
    .padding(.horizontal)
    .padding(.bottom)
    .background(Color.white)
  }
}

struct CommitView_Previews: PreviewProvider {
  static var previews: some View {
    CommitView()
  }
}
