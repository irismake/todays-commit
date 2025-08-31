import SwiftUI

struct AlertDialog<Buttons: View>: View {
  let title: String
  let message: String
  let buttons: Buttons
    
  @Binding var isPresented: Bool
    
  init(title: String, message: String, isPresented: Binding<Bool>, @ViewBuilder buttons: () -> Buttons) {
    self.title = title
    self.message = message
    _isPresented = isPresented
    self.buttons = buttons()
  }
    
  var body: some View {
    Text("")
      .alert(title, isPresented: $isPresented) {
        buttons
      } message: {
        Text(message)
      }
  }
}
