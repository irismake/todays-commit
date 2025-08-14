import SwiftUI

struct CommitView: View {
  @Environment(\.dismiss) private var dismiss
  let commitAddress: String
  let placeName: String?
  // 사용자가 입력/확정할 장소명
  @State private var inputPlaceName: String
  // 편집 가능 여부
  private let isEditable: Bool
    
  // placeName 유무에 따라 초기값/편집여부 세팅
  init(commitAddress: String, placeName: String?) {
    self.commitAddress = commitAddress
    self.placeName = placeName
    _inputPlaceName = State(initialValue: placeName ?? "")
    isEditable = (placeName?.isEmpty ?? true)
  }

  // 최종 사용할 이름(읽기 전용이면 초기값, 편집 가능이면 입력값)
  private var finalPlaceName: String {
    isEditable ? inputPlaceName : (placeName ?? "")
  }
    
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
                
            Text(commitAddress)
              .font(.subheadline).fontWeight(.semibold)
              .foregroundColor(.secondary)
              .padding()
              .frame(maxWidth: .infinity, alignment: .leading)
              .background(Color(UIColor.systemGray6))
              .cornerRadius(12)
                
            Text("장소 이름")
              .font(.subheadline)
              .fontWeight(.medium)
              .foregroundColor(.black)
              .frame(maxWidth: .infinity, alignment: .leading)
                
            // 장소명: 읽기전용 or 입력필드
            Group {
              if isEditable {
                TextField("장소 이름을 입력하세요", text: $inputPlaceName)
                  .textInputAutocapitalization(.none)
                  .disableAutocorrection(true)
                  .submitLabel(.done)
              } else {
                Text(finalPlaceName.isEmpty ? "-" : finalPlaceName)
              }
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.gray)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(12)
            .disabled(!isEditable) // 편집 불가이면 터치/키보드 비활성
                
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

      CompleteButton(onComplete: {
        // 잔디 심기
      }, title: "잔디 심기", color: Color.green)
    }
    .padding(.horizontal)
    .padding(.bottom)
    .background(Color.white)
  }
}

struct CommitView_Previews: PreviewProvider {
  static var previews: some View {
    CommitView(commitAddress: "서울 종로구 명륜2가 24-4", placeName: "공차 대학로점")
  }
}
