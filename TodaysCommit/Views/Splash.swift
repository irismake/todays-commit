import SwiftUI

struct SplashView: View {
  var body: some View {
    VStack {
      Image("logo_icon")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)
    }
  }
}

struct SplashView_Previews: PreviewProvider {
  static var previews: some View {
    SplashView()
  }
}
