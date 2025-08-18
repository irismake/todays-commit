import SwiftUI

struct CommitView: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var placeManager: PlaceManager
  var onFinish: () -> Void = {}
  @State private var inputPlaceName: String
  private let isEditable: Bool
  private let placeData: AddPlaceData
 
  init(placeData: AddPlaceData, onFinish: @escaping () -> Void) {
    self.placeData = placeData
    self.onFinish = onFinish
    _inputPlaceName = State(initialValue: placeData.name)
    isEditable = placeData.name == ""
  }

  private var finalPlaceName: String {
    isEditable ? inputPlaceName : (placeData.name)
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
                
            Text(placeData.address)
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
            .disabled(!isEditable)
                
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
        guard !inputPlaceName.isEmpty else {
          // 경고 팝업
          return
        }
          
        let updatedData = AddPlaceData(
          pnu: placeData.pnu,
          name: inputPlaceName,
          address: placeData.address,
          x: placeData.x,
          y: placeData.y
        )
        print(updatedData)
      
        await fetchPlantingGrass(of: updatedData)
        
      }, title: "잔디 심기", color: Color.green)
    }
    .padding(.horizontal)
    .padding(.bottom)
    .background(Color.white)
  }

  func fetchPlantingGrass(of addPlaceData: AddPlaceData) async {
    let overlayVC = Overlay.show(LoadingView())
    defer { overlayVC.dismiss(animated: true) }

    let grassService = GrassService.shared
    if isEditable {
      await placeManager.addPlace(of: addPlaceData)
    }
    await grassService.addGrassData(of: addPlaceData.pnu)
    dismiss()
    onFinish()
    try? await Task.sleep(nanoseconds: 1_000_000_000)
  }
}

struct CommitView_Previews: PreviewProvider {
  static var previews: some View {
    CommitView(placeData: AddPlaceData(
      pnu: "pnu",
      name: "placeName",
      address: "placeAddress",
      x: 0.0,
      y: 0.0
    ), onFinish: {})
  }
}
