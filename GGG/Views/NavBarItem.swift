import SwiftUI

struct NavBarItem: View {
  let icon: String
  let label: String

  var body: some View {
    VStack {
      Image(systemName: icon)
        .resizable()
        .frame(width: 25, height: 25)
      Text(label)
        .font(.caption)
    }
    .foregroundColor(.blue)
  }
}


struct NavBarItem_Previews: PreviewProvider {
  static var previews: some View {
    NavBarItem(icon: "house.fill", label: "Home")
  }
}
