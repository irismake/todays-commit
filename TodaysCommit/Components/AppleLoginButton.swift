import SwiftUI

struct AppleLoginButton: View {
  var body: some View {
    Button(action: {}) {
      HStack {
        Image("apple_symbol")
          .resizable()
          .renderingMode(.template)
          .aspectRatio(contentMode: .fit)
          .frame(height: 18)
          .foregroundColor(.white)
            
        Text("Sign in with Apple")
          .font(.subheadline)
          .foregroundColor(Color.white)
          .fontWeight(.medium)
      }
      .frame(height: UIScreen.main.bounds.height * 0.06)
      .frame(maxWidth: .infinity)
      .background(Color.black)
      .cornerRadius(12)
    }
  }
}

struct AppleLoginButton_Previews: PreviewProvider {
  static var previews: some View {
    AppleLoginButton()
  }
}
