import SwiftUI

struct HomeView: View {
  @State private var showNavTitle: Bool = false

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(alignment: .leading) {
          HStack {
            Text("GitGrassGrowing")
              .font(.largeTitle)
              .fontWeight(.bold)
              .padding(.top, 20)
            Spacer()
          }
                  
          ForEach(1 ... 20, id: \.self) { index in
            Text("스크롤 아이템 \(index)")
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.gray.opacity(0.2))
              .cornerRadius(10)
              .padding(.horizontal)
          }
        }
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
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: {
            print("플러스 버튼 클릭")
          }, label: {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: 24, height: 24)
              .foregroundColor(.blue)
          })
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color(UIColor.systemGray6))
    }
    .overlay(
      BottomNavBar()
        .edgesIgnoringSafeArea(.bottom),
      alignment: .bottom
    )
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
  }
}
