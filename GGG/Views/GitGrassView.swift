import SwiftUI

struct GitGrassView: View {
  @EnvironmentObject var viewModel: CommitViewModel
  @State private var selectedOption = 0
  let options = ["전체", "나의 지도"]

  var body: some View {
    NavigationView {
      ScrollView {
        VStack {
          CommitBanner(commitState: false)

          Picker("선택", selection: $selectedOption) {
            ForEach(0 ..< options.count, id: \.self) { index in
              Text(options[index])
            }
          }
          .pickerStyle(.segmented)
          .padding(.vertical, 20)

          HStack(spacing: 12) {
            ZoomButton(isZoomIn: false)
                        
            Text(viewModel.mapName)
              .font(.headline)
              .fontWeight(.semibold)
              .foregroundColor(Color(.black))
       
            ZoomButton(isZoomIn: true)
          }

          ZStack(alignment: .bottomTrailing) {
            GrassMapView(isMine: selectedOption == 1)
            locationButton()
          }

          Group {
            if selectedOption == 0 {
              TotalRankingView()
            } else {
              UserRankingView()
            }
          }
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
    let viewModel = CommitViewModel()

    GitGrassView()
      .environmentObject(viewModel)
      .previewLayout(.device)
  }
}
