import SwiftUI

struct NavBarItem: View {
  let name: String
    
  var body: some View {
    Image(name)
      .renderingMode(.template)
      .foregroundColor(.white)
      .frame(width: 40, height: 40)
  }
}

struct NavBarItem_Previews: PreviewProvider {
  static var previews: some View {
    NavBarItem(name: "icon_commit")
  }
}
