import SwiftUI

struct CommitBanner: View {
  @State private var activeSheet: Route?

  var body: some View {
    Button(action: {
      if UserSessionManager.isGuest {
        activeSheet = .login
        
      } else {
        activeSheet = .commitLocation
      }
    }) {
      VStack(spacing: 12) {
        HStack(spacing: 2) {
          Text("오늘의 커밋하기")
            .font(.headline)
            .fontWeight(.semibold)
            
          Image("icon_commit")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
        }
        .font(.headline)
        .foregroundColor(.primary)

        Text("커밋하고 잔디를 심어보세요.")
          .font(.subheadline)
          .foregroundColor(.secondary)
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.green.opacity(0.1))
      .cornerRadius(16)
    }
    .fullScreenCover(item: $activeSheet) { sheet in
      switch sheet {
      case .commitLocation:
        CommitLocationView()
      case .login:
        LoginView(isSheet: true)
      default:
        EmptyView()
      }
    }
  }
}
