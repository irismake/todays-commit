import SwiftUI

struct CommitSummaryView: View {
  let dummyCommitLevels: [[Int]] = Array(repeating: [0, 1, 2, 3, 4, 0, 1], count: 7)

  func colorForLevel(_ level: Int) -> Color {
    switch level {
    case 0: return Color.gray.opacity(0.3)
    case 1: return Color.green.opacity(0.3)
    case 2: return Color.green.opacity(0.5)
    case 3: return Color.green.opacity(0.7)
    case 4: return Color.green
    default: return Color.clear
    }
  }

  var body: some View {
    VStack(spacing: 20) {
      VStack(alignment: .leading, spacing: 20) {
        Text("📊 이번 주 커밋")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .leading)
        HStack(spacing: 8) {
          ForEach(0 ..< 7) { _ in
            RoundedRectangle(cornerRadius: 4)
              .fill(Color.green)
              .frame(width: 20, height: 20)
          }
        }
      }

      VStack(alignment: .leading, spacing: 20) {
        Text("📅 커밋 히스토리")
          .font(.headline)
          .frame(maxWidth: .infinity, alignment: .leading)

        LazyVGrid(columns: Array(repeating: GridItem(.fixed(20), spacing: 4), count: 7), spacing: 4) {
          ForEach(0 ..< dummyCommitLevels.count * 7, id: \.self) { index in
            let row = index / 7
            let col = index % 7
            RoundedRectangle(cornerRadius: 4)
              .fill(colorForLevel(dummyCommitLevels[row][col]))
              .frame(width: 20, height: 20)
          }
        }

        Text("이번 달 총 커밋 수: 42회")
          .font(.footnote)
          .foregroundColor(.gray)
      }
    }
    .padding()
    .cornerRadius(16)
  }
}
