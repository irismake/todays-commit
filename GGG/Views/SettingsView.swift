import SwiftUI

struct SettingsView: View {
  @State private var allowNotification = false
  @StateObject private var mailHandler = MailHandler()
  
  let guideSettings = [
    (icon: "book.circle", title: "Widget Setup Guide", subtitle: "Guide to adding git grass widget", hasToggle: false)
  ]
  
  let setupSettings = [
    (icon: "bell.circle", title: "Notification", subtitle: "Set up app notifications", hasToggle: true)
  ]
  
  let supportSettings = [
    (icon: "star.circle", title: "Rate the App", subtitle: "Write a review for the app", hasToggle: false),
    (icon: "paperplane.circle", title: "Contact us", subtitle: "gitgrassgrowing@gmail.com", hasToggle: false)
  ]
    
  var body: some View {
    NavigationView {
      List {
        Section(header: Text("guide")) {
          ForEach(guideSettings, id: \ .title) { option in
            Button(action: {
              handleAction(for: option.title)
            }) {
              settingsRow(option: option)
            }
          }
        }
            
        Section(header: Text("setup")) {
          ForEach(setupSettings, id: \ .title) { option in
            settingsRow(option: option)
          }
        }
          
        Section(header: Text("Support")) {
          ForEach(supportSettings, id: \.title) { option in
            Button(action: {
              handleAction(for: option.title)
            }) {
              settingsRow(option: option)
            }
          }
        }
      }
      .navigationTitle("Settings")
    }.sheet(isPresented: $mailHandler.showDefaultMailView) {
      MailView(mailHandler: mailHandler)
    }
  }
    
  private func handleAction(for title: String) {
    switch title {
    case "Widget Setup Guide":
      print("Widget Setup Guide")
          
    case "Rate the App":
      print("Rate the App")
          
    case "Contact us":
      let mailData = MailData(
        subject: "[문의사항] 앱 관련 문의드립니다.",
        content: "앱 사용 중 불편사항, 문의 또는 피드백을 작성해 주세요. 최대한 빠르게 답변드리겠습니다."
      )
      mailHandler.saveMailData(for: mailData)
      mailHandler.showMailOptions()
         
    default:
      print("Action for \(title) not implemented")
    }
  }
  
  @ViewBuilder
  private func settingsRow(option: (icon: String, title: String, subtitle: String, hasToggle: Bool)) -> some View {
    HStack(spacing: 15) {
      Image(systemName: option.icon)
        .foregroundColor(.blue)
        .font(.system(size: 20))
        .frame(width: 30, height: 30)
      VStack(alignment: .leading) {
        Text(option.title)
          .font(.headline)
          .foregroundColor(.black)
        Text(option.subtitle)
          .font(.subheadline)
          .lineLimit(1)
          .foregroundColor(.gray)
      }
      .padding(.vertical, 8)
      Spacer()
      
      if option.hasToggle {
        Toggle("", isOn: $allowNotification)
          .frame(minWidth: 0, maxWidth: 50, minHeight: 0, maxHeight: 30)
      } else {
        Image(systemName: "chevron.right")
          .foregroundColor(.gray.opacity(0.4))
          .font(.system(size: 20))
          .frame(minWidth: 0, maxWidth: 10, minHeight: 0, maxHeight: 30)
      }
    }
  }
}

struct SettingsView_Previews: PreviewProvider {
  static var previews: some View {
    SettingsView()
  }
}
