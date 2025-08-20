import SwiftUI

struct PlaceDetailView: View {
  @Environment(\.dismiss) private var dismiss
        
  var body: some View {
    let commits: [AnyView] = [
      AnyView(CommitAuthItem(createdAt: "2025-07-06 13:09", userName: "김가희")),
      AnyView(CommitAuthItem(createdAt: "2025-07-05 18:22", userName: "홍길동")),
      AnyView(CommitAuthItem(createdAt: "2025-07-04 09:41", userName: "이영희"))
    ]
    VStack(alignment: .leading) {
      HStack {
        Button(action: { dismiss() }) {
          Image(systemName: "chevron.left")
            .foregroundColor(.primary)
            .padding(.vertical)
        }
        Spacer()
      }
      .padding(.top)
      ScrollView {
        VStack(alignment: .leading) {
          Group {
            HStack {
              HStack(spacing: 4) {
                Image(systemName: "location.fill")
                  .font(.system(size: 10, weight: .semibold))
                  .foregroundColor(.secondary)
                Text("7.5km")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }

              HStack(spacing: 4) {
                Image("icon_commit")
                  .renderingMode(.template)
                  .foregroundColor(.secondary)
                  .aspectRatio(contentMode: .fit)
                  .frame(height: 10)
                         
                Text("3회")
                  .font(.caption)
                  .foregroundColor(.secondary)
              }
            }
            Text("스타벅스 성신여대점")
              .font(.title2)
              .fontWeight(.bold)
          }
            
          VStack(spacing: 10) {
            VStack(spacing: 10) {
              Button(action: {
                print("주소 버튼 탭됨")
              }) {
                HStack(spacing: 8) {
                  Image(systemName: "arrow.up.forward")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary)
                        
                  Text("서울 성북구 동선동1가 92-1")
                    .font(.caption)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.clear)
                .overlay(
                  RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.primary.opacity(0.3), lineWidth: 1)
                )
              }
              .buttonStyle(PlainButtonStyle())
              .scaleEffect(1.0)
              .animation(.easeInOut(duration: 0.1), value: false)
              .padding(.horizontal, 1)
            }
            KakaoMapButton()
          }
          .padding(.vertical)
            
          Text("커밋 내역")
            .font(.headline)
            .fontWeight(.bold)
            .padding(.vertical)
            
          ForEach(commits.indices, id: \.self) { index in
            commits[index]
          }
        }
      }
      Spacer()
      CompleteButton(
        onComplete: {},
        title: "오늘의 커밋 시작하기",
        color: Color.green
      )
      .padding(.bottom)
    }
    .padding(.horizontal)
  }
}

struct PlaceDetailView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceDetailView()
  }
}
