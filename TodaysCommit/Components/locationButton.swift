import SwiftUI
 
struct locationButton: View {
  var body: some View {
    Button(action: {
      print("현재 위치로 이동")
    }) {
      Image(systemName: "location.fill")
        .foregroundColor(.blue)
        .padding(10)
        .background(Color.white)
        .clipShape(Circle())
        .shadow(radius: 3)
    }
  }
}
