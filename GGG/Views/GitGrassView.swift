import SwiftUI

struct GitGrassView: View {
  var body: some View {
    NavigationView {
      VStack(spacing: 0) {
        ScrollView {
          VStack(alignment: .leading) {
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
        }

        .coordinateSpace(name: "scrollView")
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
      }.navigationTitle("🌱 Git Grass")
    }
  }
}
    
struct GitGrassView_Previews: PreviewProvider {
  static var previews: some View {
    GitGrassView()
  }
}
