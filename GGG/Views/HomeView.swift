import SwiftUI

struct HomeView: View {
  @State private var showNavTitle: Bool = false
  var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        ScrollView {
          VStack(alignment: .leading) {
            HStack {
              Text("GitGrassGrowing")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            }
            VStack(spacing: 10) {
              ForEach(1 ... 20, id: \.self) { index in
                Text("스크롤 아이템 \(index)")
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(Color.white)
                  .cornerRadius(10)
              }
            }
            .padding(.bottom, 20)
          }
          .padding(.horizontal)
          .background(
            GeometryReader { proxy -> Color in
              let offsetY = proxy.frame(in: .named("scrollView")).minY
              DispatchQueue.main.async {
                if offsetY < -50, !showNavTitle {
                  showNavTitle = true
                } else if offsetY > -50, showNavTitle {
                  showNavTitle = false
                }
              }
              return Color.clear
            }
          )
        }
        .coordinateSpace(name: "scrollView")
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(showNavTitle ? "GitGrassGrowing" : "")
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarItems(trailing: Button(
          action: {
            print("플러스 버튼 클릭")
          },
          label: {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: 24, height: 24)
              .foregroundColor(.blue)
          }
        )
        )
        BottomNavBar()
          .ignoresSafeArea(edges: .bottom)
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
