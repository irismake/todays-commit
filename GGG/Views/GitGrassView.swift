import SwiftUI

struct GitGrassView: View {
  @State private var selectedOption = 0
  let options = ["전체", "나의 지도"]

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          CommitBanner(commitState: false)

          VStack {
            Picker("선택", selection: $selectedOption) {
              ForEach(0 ..< options.count, id: \.self) { index in
                Text(options[index])
              }
            }
            .pickerStyle(.segmented)
          }

          HStack(spacing: 12) {
            ZoomButton(zoomAction: {
              print("Zoom Out")
            }, iconName: "minus")
                        
            Text("서울")
              .font(.headline)
              .fontWeight(.semibold)
              .foregroundColor(Color(.black))
              .padding()

            ZoomButton(zoomAction: {
              print("Zoom In")
            }, iconName: "plus")
          }

          VStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
              Image("images/seoul")
                .resizable()
                .aspectRatio(contentMode: .fit)

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
          }
          .padding()

          RankingView(isMine: selectedOption == 0 ? false : true, grassColor: Color(hue: 0.382, saturation: 0.709, brightness: 0.431))
        }
        .padding()
      }
     
      .navigationTitle("🌱 Git Grass")
      .navigationBarItems(trailing:
        Button(action: {
          print("플러스 버튼 클릭")
        }) {
          Image(systemName: "plus.circle.fill")
            .resizable()
            .frame(width: 24, height: 24)
            .foregroundColor(.blue)
        }
      )
    }
  }
}

struct GitGrassView_Previews: PreviewProvider {
  static var previews: some View {
    GitGrassView()
  }
}
