import SwiftUI

struct GitGrassView: View {
  @State private var showPopup = false
  @State private var progress: Double = 0.25
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 20) {
          Button(action: {
            showPopup = true
          }) {
            VStack(spacing: 12) {
              Label("오늘 커밋 완료!", systemImage: "checkmark.circle.fill")
                .font(.headline)
                .foregroundColor(.green)
              Text("🔥 3일 연속 커밋 중")
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green.opacity(0.1))
            .cornerRadius(16)
          }
          VStack(spacing: 12) {
            Text("🌱 잔디를 키워보세요")
              .font(.headline)
            ZStack {
              Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)
              Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .rotationEffect(.degrees(-90))
              Model3DView(modelName: "grass_1")
                .padding(20)
            }
            .frame(width: 300, height: 300)
            .padding(.vertical, 30)
          }
          .padding()
          .frame(maxWidth: .infinity)
          .background(Color.orange.opacity(0.1))
          .cornerRadius(16)
        }
        .padding()
      }
      .navigationTitle("🌱 Git Grass")
      .navigationBarItems(trailing: Button(action: {
        print("플러스 버튼 클릭")
      }, label: {
        Image(systemName: "plus.circle.fill")
          .resizable()
          .frame(width: 24, height: 24)
          .foregroundColor(.blue)
      }))
      .sheet(isPresented: $showPopup) {
        CommitSummaryView(
        )
      }
    }
  }
}

struct GitGrassView_Previews: PreviewProvider {
  static var previews: some View {
    GitGrassView()
  }
}
