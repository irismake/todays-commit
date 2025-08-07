import KakaoSDKAuth
import SwiftUI

struct RootView: View {
  @AppStorage("access_token") var accessToken: String?
  @AppStorage("is_guest") var isGuest: Bool = false
  @State private var isLoading = false

  var body: some View {
    if accessToken != nil || isGuest {
      ZStack {
        ContentView()
        if isLoading {
          Color.black.opacity(0.3).ignoresSafeArea()
          GeometryReader { _ in
            LoadingView()
          }
        }
      }   
      .task {
        isLoading = true
        do {
          let mapData = try await MapAPI.getMap(2)
          print("✅ 성공: \(mapData)")
        } catch {
          print("❌ 실패: \(error.localizedDescription)")
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isLoading = false
      }
    } else {
      LoginView()
        .onOpenURL { url in
          if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
          }
        }
    }
  }
}
