import SwiftUI

struct ProviderBadge: View {
  @Environment(\.colorScheme) var colorScheme
  let provider: String
    
  private var imageName: String {
    "\(provider)_symbol"
  }
    
  private var text: String {
    if provider == "kakao" {
      "카카오 로그인"
    } else {
      "애플 로그인"
    }
  }
      
  var body: some View {
    HStack {
      Image(imageName)
        .resizable()
        .renderingMode(.template)
        .aspectRatio(contentMode: .fit)
        .frame(height: 8)
        .foregroundColor(provider == "kakao" ? .black : (colorScheme == .dark ? .black : .white))
        .padding(4)
        .background(provider == "kakao" ? Color(hex: "#FEE500") : .primary)
        .clipShape(Circle())
        
      Text(text)
        .font(.caption)
        .foregroundColor(.secondary)
    }
  }
}
