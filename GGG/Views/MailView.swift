import MessageUI
import SwiftUI

class MailHandler: ObservableObject {
  @Published var showDefaultMailView = false
    
  func showMailOptions(for mailData: MailData) {
    let alertController = UIAlertController(
      title: "메일 보내기",
      message: "메일을 보낼 앱을 선택해주세요",
      preferredStyle: .actionSheet
    )
        
    alertController.addAction(UIAlertAction(title: "Mail 앱", style: .default) { [weak self] _ in
      if MFMailComposeViewController.canSendMail() {
        self?.showDefaultMailView = true
      } else {
        self?.showMailErrorAlert()
      }
    })
        
    alertController.addAction(UIAlertAction(title: "다른 메일 앱", style: .default) { _ in
      if let mailtoURL = mailData.mailtoURL, UIApplication.shared.canOpenURL(mailtoURL) {
        UIApplication.shared.open(mailtoURL, options: [:], completionHandler: nil)
      } else {
        self.showMailErrorAlert()
      }
    })
        
    alertController.addAction(UIAlertAction(title: "취소", style: .cancel))
        
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootViewController = windowScene.windows.first?.rootViewController
    {
      rootViewController.present(alertController, animated: true)
    }
  }
    
  private func showMailErrorAlert() {
    let alertController = UIAlertController(
      title: "메일 오류",
      message: "메일을 보낼 수 없습니다. 메일 설정을 확인해주세요.",
      preferredStyle: .alert
    )
        
    alertController.addAction(UIAlertAction(title: "확인", style: .default))
        
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let rootViewController = windowScene.windows.first?.rootViewController
    {
      rootViewController.present(alertController, animated: true)
    }
  }
}

struct MailView: UIViewControllerRepresentable {
  @Environment(\.presentationMode) var presentationMode
  var mailData: MailData
    
  func makeUIViewController(context: Context) -> MFMailComposeViewController {
    let viewController = MFMailComposeViewController()
    viewController.mailComposeDelegate = context.coordinator
    viewController.setToRecipients([mailData.recipient])
    viewController.setSubject(mailData.subject)
    viewController.setMessageBody(mailData.formattedBody, isHTML: false)
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
