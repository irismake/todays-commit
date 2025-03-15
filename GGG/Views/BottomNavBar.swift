import SwiftUI

struct BottomNavBar: View {
  var body: some View {
    HStack {
      NavBarItem(icon: "square.grid.3x3.fill", label: "Stats")
      Spacer()
      NavBarItem(icon: "gearshape.fill", label: "Settings")
    }
    .frame(height: 60)
    .padding(.horizontal, 100)
    .background(Color(UIColor.systemGray6))
  }
}

struct BottomNavBar_Previews: PreviewProvider {
  static var previews: some View {
    BottomNavBar()
  }
}
