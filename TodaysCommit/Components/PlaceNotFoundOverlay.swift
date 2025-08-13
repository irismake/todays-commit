import SwiftUI

struct PlaceNotFoundOverlay: View {
  var onCommit: () -> Void
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("장소 정보를 찾을 수 없어요.")
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundColor(.orange)

      Text("지도를 움직여서 잔디를 올바른 위치에 심어주세요.")
        .font(.caption)
        .foregroundColor(.gray)

      Text("서울특별시 용산구 한남동 683-140")
        .font(.subheadline)
        .fontWeight(.semibold)
        .foregroundColor(Color(UIColor.darkGray))
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        
      CompleteButton(onComplete: {
        print("커밋 진행")
        onCommit()
      }, title: "그래도 이 위치로 커밋하기", color: Color.orange)
    }
    .padding(.vertical)
    .padding(.bottom, 20)
    .padding(.horizontal)
    .background(Color(red: 1.0, green: 0.956, blue: 0.902))
    .clipShape(RoundedRectangle(cornerRadius: 20))
  }
}
