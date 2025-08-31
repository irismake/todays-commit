import MessageUI
import SwiftUI

class MailHandler: ObservableObject {
  @Published var mailData: MailData = .init(subject: "", content: "")
  @Published var showDefaultMailView = false
  @Published var showErrorAlert = false
  @Published var errorMessage: String = ""

  func saveMailData(for mailData: MailData) {
    self.mailData = mailData
  }
  
  func sendViaMailApp() {
    if MFMailComposeViewController.canSendMail() {
      showDefaultMailView = true
    } else {
      errorMessage = "Mail 앱을 사용할 수 없습니다. 메일 계정을 설정해주세요."
      showErrorAlert = true
    }
  }

  func sendViaOtherMailApp() {
    if let mailtoURL = mailData.mailtoURL, UIApplication.shared.canOpenURL(mailtoURL) {
      UIApplication.shared.open(mailtoURL, options: [:], completionHandler: nil)
    } else {
      errorMessage = "다른 메일 앱을 열 수 없습니다. 메일 설정을 확인해주세요."
      showErrorAlert = true
    }
  }
}

struct MailView: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode
  @ObservedObject var mailHandler: MailHandler
      
  func makeUIViewController(context: Context) -> MFMailComposeViewController {
    let viewController = MFMailComposeViewController()
    viewController.mailComposeDelegate = context.coordinator
    viewController.setToRecipients([mailHandler.mailData.recipient])
    viewController.setSubject(mailHandler.mailData.subject)
    viewController.setMessageBody(mailHandler.mailData.formattedBody, isHTML: false)
    return viewController
  }
    
  func updateUIViewController(_: MFMailComposeViewController, context _: Context) {}
    
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
    
  class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
    var parent: MailView
        
    init(_ parent: MailView) {
      self.parent = parent
    }
        
    func mailComposeController(_: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
      switch result {
      case .sent:
        print("메일 보내기 성공")
      case .cancelled:
        print("메일 보내기 취소")
      case .saved:
        print("메일 임시 저장")
      case .failed:
        print("메일 발송 실패: \(String(describing: error))")
      @unknown default:
        break
      }
            
      parent.presentationMode.wrappedValue.dismiss()
    }
  }
}
